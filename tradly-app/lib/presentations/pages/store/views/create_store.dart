import 'package:flutter/material.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/widgets/text_field.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class CreateStoreScreen extends StatefulWidget {
  const CreateStoreScreen({super.key});

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _webAddressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _storeTypeController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _courierNameController = TextEditingController();
  final _taglineController = TextEditingController(text: 'Groceries');

  @override
  void dispose() {
    _storeNameController.dispose();
    _webAddressController.dispose();
    _descriptionController.dispose();
    _storeTypeController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _courierNameController.dispose();
    _taglineController.dispose();
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
            text: 'My Store',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                Assets.images.imgEmptyStore.path,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TaTitleLargeText(
                  text: "This information is used to set up your shop",
                  color: context.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: context.colorScheme.surface,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      TATextField(
                        label: 'Store Name',
                        controller: _storeNameController,
                      ),
                      TATextField(
                        label: 'Store Web Address',
                        controller: _webAddressController,
                      ),
                      TATextField(
                        label: 'Store Description',
                        controller: _descriptionController,
                      ),
                      TATextField(
                        label: 'Store Type',
                        controller: _storeTypeController,
                      ),
                      TATextField(
                        label: 'Address',
                        controller: _addressLine1Controller,
                      ),
                      TATextField(
                        label: 'City',
                        controller: _cityController,
                      ),
                      TATextField(
                        label: 'Country',
                        controller: _countryController,
                      ),
                      TATextField(
                        label: 'Courier Name',
                        controller: _courierNameController,
                      ),
                      _taglineField(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
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
            child: const Text(
              'Create',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _taglineField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Tagline',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _taglineController.text,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _taglineController.clear();
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
