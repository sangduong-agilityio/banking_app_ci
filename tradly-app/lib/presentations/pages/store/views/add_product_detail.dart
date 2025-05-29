import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/scaffold.dart';
import 'package:tradly_app/presentations/pages/store/states/store_state.dart';
import 'package:tradly_app/presentations/widgets/button.dart';
import 'package:tradly_app/presentations/widgets/form.dart';
import 'package:tradly_app/presentations/widgets/icons.dart';
import 'package:tradly_app/presentations/widgets/snackbar.dart';
import 'package:tradly_app/presentations/widgets/text.dart';
import 'package:tradly_app/presentations/widgets/text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/presentations/pages/store/states/store_bloc.dart';
import 'package:tradly_app/presentations/pages/store/states/store_event.dart';

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

  List<String> _additionalDetails = ['Cash on delivery', 'Available'];

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
    return LoaderOverlay(
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
                if (state.isProductAdded) {
                  Navigator.pop(context);
                }
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
                    final storeId = context.read<StoreBloc>().state.stores?.id;
                    final product = ProductModel(
                      title: _productNameController.text,
                      categoryType: _categoryProductController.text,
                      price: _priceController.text,
                      newPrice: _offerPriceController.text,
                      location: _locationDescriptionController.text,
                      description: _productDescriptionController.text,
                      priceType: _priceTypeController.text,
                      imageUrl:
                          state.imageFiles?.map((e) => e.path).join(',') ?? '',
                      storeId: storeId,
                    );

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
                File(state.imageFiles![index - 1].path), index - 1);
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
              color: context.colorScheme.onSecondary,
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
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: TAIcons.close(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
