import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/store/repositories/store_repo.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/widgets/card.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/features/store/states/store_bloc.dart';
import 'package:tradly_app/features/store/states/store_event.dart';
import 'package:tradly_app/features/store/states/store_state.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/form.dart';
import 'package:tradly_app/widgets/icons.dart';
import 'package:tradly_app/widgets/text.dart';
import 'package:tradly_app/widgets/text_field.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceTypeController = TextEditingController();
  final int _maxPhotos = 4;

  List<String> _additionalDetails = ['Cash on delivery', 'Available'];

  @override
  void dispose() {
    _productNameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _priceTypeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<StoreBloc>()
        .add(InitializeEditProductEvt(product: widget.product));

    return BlocProvider(
      create: (context) => StoreBloc(
        repo: context.read<StoreRepository>(),
      ),
      child: LoaderOverlay(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: TAScaffold(
            appBar: TAAppBar(
              toolbarHeight: TAAppBarSize.small,
              backgroundColor: context.colorScheme.primary,
              title: Padding(
                padding: EdgeInsets.only(left: 16),
                child: TADisplaySmallText(
                  text: S.current.storeEditProductTitle,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: BlocBuilder<StoreBloc, StoreState>(
              builder: (context, state) {
                if (state.productToEdit != null) {
                  _productNameController.text =
                      state.productToEdit?.title ?? '';
                  _categoryController.text =
                      state.productToEdit?.categoryType ?? '';
                  _priceController.text = state.productToEdit?.price ?? '';
                  _locationController.text =
                      state.productToEdit?.location ?? '';
                  _priceTypeController.text =
                      state.productToEdit?.priceType ?? '';
                  _descriptionController.text =
                      state.productToEdit?.description ?? '';
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        child: _buildPhotoUploadSection(state),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TATitleLargeText(
                          text: S.current.storeMaxPhotoProductTitle,
                          color: context.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 27),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: context.colorScheme.onPrimary,
                        child: Form(
                          key: _formKey,
                          child: BlocBuilder<StoreBloc, StoreState>(
                            builder: (context, state) {
                              return TAForm(
                                  isValidated: (valid) =>
                                      context.read<StoreBloc>().add(
                                            EditFormValidateChangedEvt(
                                              isValidate: valid,
                                              product: widget.product,
                                            ),
                                          ),
                                  textFields: [
                                    TATextField(
                                      label: S.current.storeProductNameLabel,
                                      controller: _productNameController,
                                    ),
                                    TATextField(
                                      label:
                                          S.current.storeCategoryProductLabel,
                                      controller: _categoryController,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TATextField(
                                            label: S.current.storePriceLabel,
                                            controller: _priceController,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: TATextField(
                                            label:
                                                S.current.storeOfferPriceLabel,
                                            controller: _priceTypeController,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TATextField(
                                      label:
                                          S.current.storeLocationDetailsLabel,
                                      controller: _locationController,
                                      suffixIcon: TAIcons.map(),
                                    ),
                                    TATextField(
                                      label: S
                                          .current.storeProductDescriptionLabel,
                                      controller: _descriptionController,
                                    ),
                                    TATextField(
                                      label: S.current.storePriceTypeLabel,
                                      controller: _priceTypeController,
                                    ),
                                    TATextField(
                                      label: S.current.storeAddDeataisLabel,
                                      isChipInput: true,
                                      chips: _additionalDetails,
                                      onChipsChanged: (chips) {
                                        setState(() {
                                          _additionalDetails = chips;
                                        });
                                      },
                                    ),
                                  ]);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar: BlocBuilder<StoreBloc, StoreState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  color: context.colorScheme.onPrimary,
                  child: TAElevatedButton(
                    text: S.current.storeEditProductButton,
                    backgroundColor: context.colorScheme.primary,
                    onPressed: () {
                      final storeId =
                          context.read<StoreBloc>().state.stores?.id;

                      if (_formKey.currentState?.validate() ?? false) {
                        context.loaderOverlay.show();
                        final updatedProduct = ProductModel(
                          id: widget.product.id,
                          title: _productNameController.text,
                          price: _priceController.text,
                          description: _descriptionController.text,
                          location: _locationController.text,
                          priceType: _priceTypeController.text,
                          imageUrl:
                              state.imageFiles?.map((e) => e.path).join(',') ??
                                  '',
                          storeId: storeId,
                          addtionalDetail: _additionalDetails,
                        );

                        Navigator.pop(context, updatedProduct);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUploadSection(StoreState state) {
    return TAPhotoUpload(
      imageFiles: state.imageFiles?.map((e) => File(e.path)).toList() ?? [],
      maxPhotos: _maxPhotos,
      onAddPhoto: () {
        context.read<StoreBloc>().add(
              PickImageEvt(
                maxPhotos: _maxPhotos,
                source: ImageSource.gallery,
              ),
            );
      },
      onRemovePhoto: (index) {
        context.read<StoreBloc>().add(RemoveImageEvt(image: index));
      },
    );
  }
}
