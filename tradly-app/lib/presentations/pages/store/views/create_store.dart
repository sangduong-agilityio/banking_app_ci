import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final formKey = GlobalKey<FormState>();
  final storeNameController = TextEditingController();
  final webAddressController = TextEditingController();
  final descriptionController = TextEditingController();
  final storeTypeController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final cityController = TextEditingController();
  final courierNameController = TextEditingController();
  final countryController = TextEditingController();

  List<String> _tagLineDetail = ['Vegetables', 'Fruit'];

  @override
  void dispose() {
    storeNameController.dispose();
    webAddressController.dispose();
    descriptionController.dispose();
    storeTypeController.dispose();
    addressLine1Controller.dispose();
    cityController.dispose();
    courierNameController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TAScaffold(
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
      body: SingleChildScrollView(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: context.colorScheme.surface,
                child: Form(
                  key: formKey,
                  child: BlocBuilder<StoreBloc, StoreState>(
                    builder: (context, state) {
                      return TAForm(
                          isValidated: (valid) => context.read<StoreBloc>().add(
                                CreateStoreFormValidateChagedEvt(
                                  isValidate: valid,
                                  store: widget.store,
                                ),
                              ),
                          spaceBetweenRow: 20,
                          textFields: [
                            TATextField(
                              label: S.current.storeNameLabel,
                              controller: storeNameController,
                            ),
                            TATextField(
                              label: S.current.storeWebAddressLabel,
                              controller: webAddressController,
                            ),
                            TATextField(
                              label: S.current.storeDescriptionLabel,
                              controller: descriptionController,
                            ),
                            TATextField(
                              label: S.current.storeTypeLabel,
                              controller: storeTypeController,
                            ),
                            TATextField(
                              label: S.current.storeAddressLabel,
                              controller: addressLine1Controller,
                            ),
                            TATextField(
                              label: S.current.storeCityLabel,
                              controller: cityController,
                            ),
                            TATextField(
                              label: S.current.storeCountryLabel,
                              controller: countryController,
                            ),
                            TATextField(
                              label: S.current.storeCourierNameLabel,
                              controller: courierNameController,
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
      bottomNavigationBar: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(20),
            color: context.colorScheme.onPrimary,
            child: TAElevatedButton(
              text: S.current.storeCreateButton,
              backgroundColor: context.colorScheme.primary,
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final newStore = StoreModel(
                    name: storeNameController.text,
                    webAddress: webAddressController.text,
                    description: descriptionController.text,
                  );
                  Navigator.pop(context, newStore);
                  context.read<StoreBloc>().add(
                        CreateStoreButtonEvt(store: newStore),
                      );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
