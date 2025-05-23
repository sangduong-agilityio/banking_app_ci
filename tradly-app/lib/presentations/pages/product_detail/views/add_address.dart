import 'package:flutter/material.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/core/utils/location_helper.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/scaffold.dart';
import 'package:tradly_app/presentations/widgets/assets.dart';
import 'package:tradly_app/presentations/widgets/button.dart';
import 'package:tradly_app/presentations/widgets/form.dart';
import 'package:tradly_app/presentations/widgets/text.dart';
import 'package:tradly_app/presentations/widgets/text_field.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationHelper.getCurrentPosition();
      final address = await LocationHelper.getAddressFromPosition(position);
      setState(() {
        _addressController.text = address.street ?? '';
        _cityController.text = address.city ?? '';
        _stateController.text = address.state ?? '';
        _zipCodeController.text = address.zipCode ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TAScaffold(
        backgroundColor: context.colorScheme.onPrimary,
        appBar: TAAppBar.checkout(
          title: S.current.checkoutAddAdressTitle,
          onBackPressed: () => Navigator.pop(context),
          backgroundColor: context.colorScheme.primary,
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _getCurrentLocation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.onPrimary,
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.onPrimaryContainer
                              .withOpacity(0.2),
                          blurRadius: 15,
                          offset: Offset(0, 15),
                        ),
                      ],
                    ),
                    height: 65,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TAAssets.currentLocation(),
                        const SizedBox(width: 8),
                        TAHeadlineSmallText(
                          fontWeight: FontWeight.w500,
                          text: S.current.checkoutUseCurrentLocationTitle,
                          color: context.colorScheme.onInverseSurface,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(27),
                  color: context.colorScheme.onPrimary,
                  child: Form(
                    key: _formKey,
                    child: TAForm(
                      isValidated: (valid) => null,
                      textFields: [
                        TATextField(
                          controller: _nameController,
                          label: S.current.checkoutNameLabel,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.current.checkoutNameLabel;
                            }
                            return null;
                          },
                        ),
                        TATextField(
                          controller: _phoneController,
                          label: S.current.checkoutPhoneLabel,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.current.checkoutPhoneLabel;
                            }
                            return null;
                          },
                        ),
                        TATextField(
                          controller: _addressController,
                          label: S.current.checkoutAddressLabel,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.current.checkoutAddressLabel;
                            }
                            return null;
                          },
                        ),
                        TATextField(
                          controller: _cityController,
                          label: S.current.checkoutCityLabel,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.current.checkoutCityLabel;
                            }
                            return null;
                          },
                        ),
                        TATextField(
                          controller: _stateController,
                          label: S.current.checkoutStateLabel,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.current.checkoutStateLabel;
                            }
                            return null;
                          },
                        ),
                        TATextField(
                          controller: _zipCodeController,
                          label: S.current.checkoutZipCodeLabel,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.current.checkoutZipCodeLabel;
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          color: context.colorScheme.onPrimary,
          child: TAElevatedButton(
            // isDisabled: !state.isFormValid,
            text: S.current.checkoutSaveButton,
            backgroundColor: context.colorScheme.primary,
            onPressed: () {},
          ),
        ));
  }
}
