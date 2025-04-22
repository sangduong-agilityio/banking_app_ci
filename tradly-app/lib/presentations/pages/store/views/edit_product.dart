import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/pages/store/states/store_bloc.dart';
import 'package:tradly_app/presentations/pages/store/states/store_event.dart';
import 'package:tradly_app/presentations/pages/store/states/store_state.dart';
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
  final _stockController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _additionalDetailsController = TextEditingController();
  final _priceTypeController = TextEditingController();
  final int _maxPhotos = 4;

  @override
  void dispose() {
    _productNameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _priceTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.inversePrimary,
      appBar: TaAppBar(
        toolbarHeight: TaAppBarSize.small,
        backgroundColor: context.colorScheme.primary,
        title: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: TaDisplaySmallText(
            text: 'Edit Product',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: context.colorScheme.onPrimary,
                child: Column(
                  children: [
                    _buildPhotoUploadSection(state),
                    const SizedBox(height: 16),
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
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    TATextField(
                      label: S.current.storeLocationDetailsLabel,
                      controller: _locationController,
                      suffixIcon: Icons.map,
                    ),
                    TATextField(
                      label: S.current.storeProductDescriptionLabel,
                      controller: _descriptionController,
                    ),
                    const SizedBox(height: 16),
                    TATextField(
                      label: S.current.storePriceTypeLabel,
                      controller: _priceTypeController,
                    ),
                    const SizedBox(height: 16),
                    TATextField(
                      label: S.current.storeAddDeataisLabel,
                      controller: _additionalDetailsController,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final updatedProduct = ProductModel(
                    title: _productNameController.text,
                    categoryType: _categoryController.text,
                    price: _priceController.text,
                    newPrice: _stockController.text,
                    location: _locationController.text,
                    description: _descriptionController.text,
                    priceType: _priceTypeController.text,
                    imageUrl: context
                            .read<StoreBloc>()
                            .state
                            .imageFiles!
                            .isNotEmpty
                        ? context.read<StoreBloc>().state.imageFiles!.first.path
                        : '');

                Navigator.pop(context, updatedProduct);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
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
            return _buildPhotoBox(state.imageFiles![index - 1], index - 1);
          }
        },
      ),
    );
  }

  Widget _buildAddPhotoBox() {
    return GestureDetector(
      onTap: () {
        context.read<StoreBloc>().add(
              EditProductPickImageEvt(maxPhotos: _maxPhotos),
            );
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 30,
              color: Colors.grey[400],
            ),
            TaTitleLargeText(
              text: S.current.storeAddPhotoTitle,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            ),
            TaLabelLargeText(
              text: S.current.storeAddPhotoDescription,
              color: Colors.grey[400],
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
                context.read<StoreBloc>().add(
                      RemoveImageEvt(index: index),
                    );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
