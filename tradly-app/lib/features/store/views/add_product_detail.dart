import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/store/repositories/store_repo.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/widgets/card.dart';
import 'package:tradly_app/widgets/dialog.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/features/store/states/store_state.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/form.dart';
import 'package:tradly_app/widgets/icons.dart';
import 'package:tradly_app/widgets/snackbar.dart';
import 'package:tradly_app/widgets/text.dart';
import 'package:tradly_app/widgets/text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/store/states/store_bloc.dart';
import 'package:tradly_app/features/store/states/store_event.dart';
import 'package:tradly_app/utils/details_util.dart';

class AddProductDetailScreen extends StatefulWidget {
  const AddProductDetailScreen({
    super.key,
    this.product,
  });

  final ProductModel? product;

  @override
  State<AddProductDetailScreen> createState() => _AddProductDetailScreenState();
}

class _AddProductDetailScreenState extends State<AddProductDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _categoryProductController = TextEditingController();
  final _priceController = TextEditingController();
  final _offerPriceController = TextEditingController();
  final _locationDescriptionController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _additionalDetailsController = TextEditingController();
  final _priceTypeController = TextEditingController();
  final int _maxPhotos = 4;
  List<String> _additionalDetails = TADetails.getAdditionalDetails();

  @override
  void dispose() {
    _productNameController.dispose();
    _categoryProductController.dispose();
    _priceController.dispose();
    _offerPriceController.dispose();
    _locationDescriptionController.dispose();
    _productDescriptionController.dispose();
    _additionalDetailsController.dispose();
    _priceTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreBloc(
        repo: context.read<StoreRepository>(),
      ),
      child: LoaderOverlay(
        child: TAScaffold(
          appBar: TAAppBar(
            toolbarHeight: TAAppBarSize.small,
            backgroundColor: context.colorScheme.primary,
            title: Padding(
              padding: EdgeInsets.only(left: 16),
              child: TADisplaySmallText(
                text: S.current.storeAddProductButton,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: BlocListener<StoreBloc, StoreState>(
            listener: (context, state) {
              state.status.maybeWhen(
                orElse: () {
                  context.loaderOverlay.hide();
                },
                success: () {
                  context.loaderOverlay.hide();
                },
                loading: () {
                  context.loaderOverlay.show();
                },
                failure: () {
                  context.loaderOverlay.hide();
                  TASnackBar.buildErrorSnackbar(
                    context,
                    state.errorMessage ?? '',
                  );
                },
              );
            },
            child: BlocBuilder<StoreBloc, StoreState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TATitleLargeText(
                          text: S.current.storeMaxPhotoProductTitle,
                          color: context.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 27),
                      Container(
                        padding: const EdgeInsets.all(20),
                        color: context.colorScheme.onPrimary,
                        child: Form(
                          key: _formKey,
                          child: TAForm(
                            isValidated: (isValidate) =>
                                context.read<StoreBloc>().add(
                                      AddProductFormValidateChangedEvt(
                                        isValidate: isValidate,
                                        products: state.products,
                                      ),
                                    ),
                            spaceBetweenRow: 20,
                            textFields: [
                              TATextField(
                                label: S.current.storeProductNameLabel,
                                controller: _productNameController,
                              ),
                              TATextField(
                                label: S.current.storeCategoryProductLabel,
                                controller: _categoryProductController,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TATextField(
                                      prefixIcon: TAIcons.attachMoney(),
                                      label: S.current.storePriceLabel,
                                      controller: _priceController,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TATextField(
                                      prefixIcon: TAIcons.attachMoney(),
                                      label: S.current.storeOfferPriceLabel,
                                      controller: _offerPriceController,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              TATextField(
                                label: S.current.storeLocationDetailsLabel,
                                controller: _locationDescriptionController,
                                suffixIcon: TAIcons.map(),
                              ),
                              TATextField(
                                label: S.current.storeProductDescriptionLabel,
                                controller: _productDescriptionController,
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: BlocBuilder<StoreBloc, StoreState>(
            builder: (context, state) {
              final isFormValid = !state.isFormValid;
              final hasImages = state.imageFiles?.isNotEmpty ?? false;

              return Container(
                padding: const EdgeInsets.all(20),
                color: context.colorScheme.onPrimary,
                child: TAElevatedButton(
                  isDisabled: !(isFormValid && hasImages),
                  backgroundColor: context.colorScheme.primary,
                  text: S.current.storeAddProductButton,
                  onPressed: () {
                    if (isFormValid && hasImages) {
                      final storeId =
                          context.read<StoreBloc>().state.stores?.id;
                      final product = ProductModel(
                        title: _productNameController.text,
                        categoryType: _categoryProductController.text,
                        price: _priceController.text,
                        newPrice: _offerPriceController.text,
                        location: _locationDescriptionController.text,
                        description: _productDescriptionController.text,
                        priceType: _priceTypeController.text,
                        imageUrl:
                            state.imageFiles?.map((e) => e.path).join(',') ??
                                '',
                        storeId: storeId,
                        addtionalDetail: _additionalDetails,
                      );
                      Navigator.pop(context);
                      context
                          .read<StoreBloc>()
                          .add(AddProductButtonEvt(product: product));
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
    return TAPhotoUpload(
      imageFiles: state.imageFiles?.map((e) => File(e.path)).toList() ?? [],
      maxPhotos: _maxPhotos,
      onAddPhoto: () async {
        final source = await _showImageSourceDialog(context);
        if (source != null) {
          context.read<StoreBloc>().add(
                PickImageEvt(maxPhotos: _maxPhotos, source: source),
              );
        }
      },
      onRemovePhoto: (index) {
        context.read<StoreBloc>().add(RemoveImageEvt(image: index));
      },
    );
  }

  Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return showDialog<ImageSource>(
      context: context,
      builder: (context) => TADialog(
        title: S.current.storePhotoTitleDialog,
        content: S.current.storePhotoContentDialog,
        confirmButton: S.current.storePhotoCammeraButon,
        confirmCancel: S.current.storePhotoGalleryButton,
        onAccept: () {
          Navigator.pop(context, ImageSource.camera);
        },
        onCancel: () {
          Navigator.pop(context, ImageSource.gallery);
        },
      ),
    );
  }
}
