import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/models/store_model.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/scaffold.dart';
import 'package:tradly_app/presentations/pages/store/states/store_bloc.dart';
import 'package:tradly_app/presentations/pages/store/states/store_event.dart';
import 'package:tradly_app/presentations/pages/store/states/store_state.dart';
import 'package:tradly_app/presentations/widgets/button.dart';
import 'package:tradly_app/presentations/widgets/form.dart';
import 'package:tradly_app/presentations/widgets/snackbar.dart';
import 'package:tradly_app/presentations/widgets/text_field.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class CreateStoreScreen extends StatefulWidget {
  const CreateStoreScreen({
    super.key,
    this.store,
  });

  final StoreModel? store;

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _storeWebAddressController = TextEditingController();
  final _storeDescriptionController = TextEditingController();
  final _storeTypeController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _courierNameController = TextEditingController();
  final _countryController = TextEditingController();

  List<String> _tagLineDetail = ['Vegetables', 'Fruit'];

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeWebAddressController.dispose();
    _storeDescriptionController.dispose();
    _storeTypeController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _courierNameController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: TAScaffold(
        backgroundColor: context.colorScheme.inversePrimary,
        appBar: TAAppBar(
          toolbarHeight: TAAppBarSize.small,
          backgroundColor: context.colorScheme.primary,
          title: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Semantics(
              child: TADisplaySmallText(
                text: S.current.storeTitle,
                fontWeight: FontWeight.w700,
              ),
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
                Navigator.pop(context);
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
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    height: 120,
                    Assets.images.imgEmptyStore.path,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Semantics(
                      child: TATitleLargeText(
                        textAlign: TextAlign.center,
                        text: S.current.storeDetailTitle,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    color: context.colorScheme.surface,
                    child: Form(
                      key: _formKey,
                      child: BlocBuilder<StoreBloc, StoreState>(
                        buildWhen: (previous, current) => previous != current,
                        builder: (context, state) {
                          return TAForm(
                              isValidated: (valid) =>
                                  context.read<StoreBloc>().add(
                                        CreateStoreFormValidateChangedEvt(
                                          isValidate: valid,
                                          store: widget.store,
                                        ),
                                      ),
                              spaceBetweenRow: 20,
                              textFields: [
                                TATextField(
                                  label: S.current.storeNameLabel,
                                  controller: _storeNameController,
                                ),
                                TATextField(
                                  label: S.current.storeWebAddressLabel,
                                  controller: _storeWebAddressController,
                                ),
                                TATextField(
                                  label: S.current.storeDescriptionLabel,
                                  controller: _storeDescriptionController,
                                ),
                                TATextField(
                                  label: S.current.storeTypeLabel,
                                  controller: _storeTypeController,
                                ),
                                TATextField(
                                  label: S.current.storeAddressLabel,
                                  controller: _addressController,
                                ),
                                TATextField(
                                  label: S.current.storeCityLabel,
                                  controller: _cityController,
                                ),
                                TATextField(
                                  label: S.current.storeCountryLabel,
                                  controller: _countryController,
                                ),
                                TATextField(
                                  label: S.current.storeCourierNameLabel,
                                  controller: _courierNameController,
                                ),
                                TATextField(
                                  label: S.current.storeTaglineLabel,
                                  isChipInput: true,
                                  chips: _tagLineDetail,
                                  onChipsChanged: (chips) {
                                    setState(() {
                                      _tagLineDetail = chips;
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
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<StoreBloc, StoreState>(
          buildWhen: (previous, current) =>
              previous.isFormValid != current.isFormValid,
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(20),
              color: context.colorScheme.onPrimary,
              child: TAElevatedButton(
                isDisabled: !state.isFormValid,
                text: S.current.storeCreateButton,
                backgroundColor: context.colorScheme.primary,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final store = StoreModel(
                      storeName: _storeNameController.text,
                      storeWebAddress: _storeWebAddressController.text,
                      storeDescription: _storeDescriptionController.text,
                      storeType: _storeTypeController.text,
                      address: _addressController.text,
                      city: _cityController.text,
                      country: _countryController.text,
                      courieName: _courierNameController.text,
                    );

                    context
                        .read<StoreBloc>()
                        .add(CreateStoreButtonEvt(store: store));
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
