import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/widgets/text.dart';
import 'dart:io';

import 'package:tradly_app/presentations/widgets/text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/presentations/pages/store/states/store_bloc.dart';
import 'package:tradly_app/presentations/pages/store/states/store_event.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _additionalDetailsController = TextEditingController();
  final _priceTypeController = TextEditingController();

  final List<File> _imageFiles = [];
  final _picker = ImagePicker();
  final int _maxPhotos = 4;

  @override
  void dispose() {
    _productNameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _additionalDetailsController.dispose();
    _priceTypeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_imageFiles.length >= _maxPhotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum $_maxPhotos photos allowed'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1200,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.inversePrimary,
      appBar: TaAppBar(
        toolbarHeight: TaAppBarSize.small,
        backgroundColor: context.colorScheme.primary,
        title: Padding(
          padding: EdgeInsets.only(left: 16),
          child: TaDisplaySmallText(
            text: S.current.storeAddProductButton,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _buildPhotoUploadSection(),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TaTitleLargeText(
                text: 'Max. $_maxPhotos photos per product',
                color: context.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 27),
            Form(
              key: _formKey,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: context.colorScheme.onPrimary,
                child: Column(
                  children: [
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
                    const SizedBox(height: 8),
                    // Row(
                    //   children: const [
                    //     ProductChip(label: 'Cash on delivery'),
                    //     SizedBox(width: 8),
                    //     ProductChip(label: 'Available'),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_imageFiles.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please add at least one product image'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                final product = ProductModel(
                  title: _productNameController.text,
                  categoryType: _categoryController.text,
                  price: _priceController.text,
                  location: _locationController.text,
                  description: _descriptionController.text,
                  priceType: _priceTypeController.text,
                  imageUrl:
                      _imageFiles.isNotEmpty ? _imageFiles.first.path : '',
                );

                context
                    .read<StoreBloc>()
                    .add(AddProductEvent(product: product));
                Navigator.pop(context, true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              disabledBackgroundColor:
                  context.colorScheme.primary.withOpacity(0.6),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: TaHeadlineMediumText(
              text: S.current.storeAddProductButton,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUploadSection() {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imageFiles.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _buildAddPhotoBox(),
            );
          } else {
            return _buildPhotoBox(index - 1);
          }
        },
      ),
    );
  }

  Widget _buildAddPhotoBox() {
    return GestureDetector(
      onTap: _pickImage,
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

  Widget _buildPhotoBox(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 140,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              _imageFiles[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeImage(index),
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
