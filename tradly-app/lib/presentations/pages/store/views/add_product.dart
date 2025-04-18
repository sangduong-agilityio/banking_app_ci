import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradly_app/presentations/pages/store/views/product_chip.dart';
import 'dart:io';

import 'package:tradly_app/presentations/widgets/text_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _categoryController = TextEditingController(text: 'Vegetables');
  final _priceController = TextEditingController(text: '30');
  final _stockController = TextEditingController(text: '15');
  final _locationController =
      TextEditingController(text: 'Kualalumpur, Malaysia');
  final _descriptionController = TextEditingController();

  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void dispose() {
    _productNameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Product',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add product image',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Max 4 photos per product',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),
                TATextField(
                  label: 'Product Name',
                  controller: _productNameController,
                  hint: 'Broccoli',
                ),
                TATextField(
                  label: 'Product Category',
                  controller: _categoryController,
                  hint: 'Vegetables',
                ),
                Row(
                  children: [
                    Expanded(
                      child: TATextField(
                        label: 'Price (\$)',
                        controller: _priceController,
                        hint: '30',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TATextField(
                        label: 'Stock',
                        controller: _stockController,
                        hint: '15',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                TATextField(
                  label: 'Location/Shop',
                  controller: _locationController,
                  hint: 'Kualalumpur, Malaysia',
                  suffixIcon: Icons.location_on_outlined,
                ),
                TATextField(
                  label: 'Product Description',
                  controller: _descriptionController,
                  hint:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc varius et felis at amet.',
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Price Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fixed Price',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Additional Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    ProductChip(label: 'Organic Product'),
                    SizedBox(width: 8),
                    ProductChip(label: 'Homemade'),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context, true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
