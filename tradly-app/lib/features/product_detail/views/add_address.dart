import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_state.dart';
import 'package:tradly_app/widgets/assets.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/dialog.dart';
import 'package:tradly_app/widgets/form.dart';
import 'package:tradly_app/widgets/snackbar.dart';
import 'package:tradly_app/widgets/text.dart';
import 'package:tradly_app/widgets/text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_bloc.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_event.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> _onGetCurrentLocation() async {
    final status = await Permission.location.status;
    if (status.isGranted || status.isLimited) {
      if (!mounted) return;
      context
          .read<ProductDetailBloc>()
          .add(ProductDetailGetCurrentLocationEvt());
    } else if (status.isDenied) {
      final result = await Permission.location.request();
      if (result.isGranted) {
        if (!mounted) return;
        context
            .read<ProductDetailBloc>()
            .add(ProductDetailGetCurrentLocationEvt());
      }
    } else if (status.isPermanentlyDenied) {
      if (!mounted) return;
      _showCurrentLocationPermissionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: TAScaffold(
        backgroundColor: context.colorScheme.onPrimary,
        appBar: TAAppBar.checkout(
          title: S.current.checkoutAddAdressTitle,
          onBackPressed: () => Navigator.pop(context),
          backgroundColor: context.colorScheme.primary,
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: BlocListener<ProductDetailBloc, ProductDetailState>(
            listener: (context, state) {
              state.status.maybeWhen(
                orElse: () {
                  context.loaderOverlay.hide();
                },
                success: () {
                  final address = state.product;
                  if (address != null) {
                    _addressController.text = address.street ?? '';
                    _cityController.text = address.city ?? '';
                    _stateController.text = address.state ?? '';
                    _zipCodeController.text = address.zipCode ?? '';
                  }
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _onGetCurrentLocation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.onPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.onPrimaryContainer
                                .withAlpha(50),
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
                      child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                        buildWhen: (previous, current) =>
                            previous.isFormValid != current.isFormValid,
                        builder: (context, state) {
                          return TAForm(
                            isValidated: (isValid) =>
                                context.read<ProductDetailBloc>().add(
                                      ProductDetailFormValidateChangedEvt(
                                        isValidate: isValid,
                                      ),
                                    ),
                            textFields: [
                              TATextField(
                                controller: _nameController,
                                label: S.current.checkoutNameLabel,
                              ),
                              TATextField(
                                controller: _phoneController,
                                label: S.current.checkoutPhoneLabel,
                              ),
                              TATextField(
                                controller: _addressController,
                                label: S.current.checkoutAddressLabel,
                              ),
                              TATextField(
                                controller: _cityController,
                                label: S.current.checkoutCityLabel,
                              ),
                              TATextField(
                                controller: _stateController,
                                label: S.current.checkoutStateLabel,
                              ),
                              TATextField(
                                controller: _zipCodeController,
                                label: S.current.checkoutZipCodeLabel,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(20),
              color: context.colorScheme.onPrimary,
              child: TAElevatedButton(
                isDisabled: !state.isFormValid,
                text: S.current.checkoutSaveButton,
                backgroundColor: context.colorScheme.primary,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final product = ProductModel(
                      price: '',
                      imageUrl: '',
                      title: _nameController.text,
                      street: _addressController.text,
                      city: _cityController.text,
                      state: _stateController.text,
                      zipCode: _zipCodeController.text,
                    );

                    context.read<ProductDetailBloc>().add(
                          ProductDetailAddAddressEvt(product: product),
                        );
                    Navigator.pop(context, product);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future _showCurrentLocationPermissionDialog(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return TADialog(
          title: S.current.productDetailLocationServiceTitle,
          content: S.current.productDetailLocationServiceContent,
          confirmButton: S.current.productDetailLocationGoToSettingsButton,
          confirmCancel: S.current.productDetailLocationCancelButton,
          onAccept: () {
            openAppSettings();
            Navigator.pop(context);
          },
          onCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
