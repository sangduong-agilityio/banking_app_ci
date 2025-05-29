import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/scaffold.dart';
import 'package:tradly_app/presentations/pages/store/states/store_bloc.dart';
import 'package:tradly_app/presentations/pages/store/states/store_event.dart';
import 'package:tradly_app/presentations/pages/store/states/store_state.dart';
import 'package:tradly_app/presentations/widgets/button.dart';
import 'package:tradly_app/presentations/widgets/form.dart';
import 'package:tradly_app/presentations/widgets/icons.dart';
import 'package:tradly_app/presentations/widgets/text.dart';
import 'package:tradly_app/presentations/widgets/text_field.dart';

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

    return LoaderOverlay(
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
                _productNameController.text = state.productToEdit?.title ?? '';
                _categoryController.text =
                    state.productToEdit?.categoryType ?? '';
                _priceController.text = state.productToEdit?.price ?? '';
                _locationController.text = state.productToEdit?.location ?? '';
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
                                    label: S.current.storeCategoryProductLabel,
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
                                          label: S.current.storeOfferPriceLabel,
                                          controller: _priceTypeController,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TATextField(
                                    label: S.current.storeLocationDetailsLabel,
                                    controller: _locationController,
                                    suffixIcon: TAIcons.map(),
                                  ),
                                  TATextField(
                                    label:
                                        S.current.storeProductDescriptionLabel,
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
                    final storeId = context.read<StoreBloc>().state.stores?.id;

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
                      );

                      Future.delayed(const Duration(seconds: 1), () {
                        if (context.mounted) {
                          context.loaderOverlay.hide();
                          Navigator.pop(context, updatedProduct);
                        }
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUploadSection(StoreState state) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (state.imageFiles?.length ?? 0) + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _buildAddPhotoBox(),
            );
          } else {
            return _buildPhotoBox(
              File(state.imageFiles![index - 1].path),
              index - 1,
            );
          }
        },
      ),
    );
  }

  Widget _buildAddPhotoBox() {
    return GestureDetector(
      onTap: () {
        context.read<StoreBloc>().add(
              PickImageEvt(maxPhotos: _maxPhotos),
            );
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.colorScheme.onPrimaryContainer,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TAIcons.add(),
            TATitleLargeText(
              text: S.current.storeAddPhotoTitle,
              color: context.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
            TALabelLargeText(
              text: S.current.storeAddPhotoDescription,
              color: context.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoBox(File imageFile, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 140,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                context.read<StoreBloc>().add(RemoveImageEvt(image: index));
              },
              child: Container(
                decoration: BoxDecoration(
                    color:
                        context.colorScheme.onSecondaryContainer.withAlpha(150),
                    shape: BoxShape.circle),
                child: TAIcons.close(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
