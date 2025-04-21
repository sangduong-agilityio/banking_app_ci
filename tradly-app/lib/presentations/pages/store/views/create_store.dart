import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/repositories/store_repo.dart.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/pages/store/states/store_bloc.dart';
import 'package:tradly_app/presentations/pages/store/states/store_event.dart';
import 'package:tradly_app/presentations/widgets/text_field.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class CreateStoreScreen extends StatefulWidget {
  const CreateStoreScreen({super.key});

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final storeNameController = TextEditingController();
    final webAddressController = TextEditingController();
    final descriptionController = TextEditingController();
    final storeTypeController = TextEditingController();
    final addressLine1Controller = TextEditingController();
    final cityController = TextEditingController();
    final courierNameController = TextEditingController();
    final countryController = TextEditingController();
    final taglineController = TextEditingController(text: 'Groceries');

    return BlocProvider(
      create: (context) => StoreBloc(
        repo: context.read<StoreRepository>(),
      )..add(
          CreateStoreEvent(
            storeName: storeNameController.text,
            webAddress: webAddressController.text,
            description: descriptionController.text,
            storeType: storeTypeController.text,
            address: addressLine1Controller.text,
            city: cityController.text,
            country: countryController.text,
            courierName: courierNameController.text,
            tagLine: taglineController.text,
          ),
        ),
      child: Scaffold(
        backgroundColor: context.colorScheme.inversePrimary,
        appBar: TaAppBar(
          toolbarHeight: TaAppBarSize.small,
          backgroundColor: context.colorScheme.primary,
          title: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TaDisplaySmallText(
              text: S.current.storeTitle,
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
                  height: 120,
                  Assets.images.imgEmptyStore.path,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TaTitleLargeText(
                    textAlign: TextAlign.center,
                    text: S.current.storeDetailTitle,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: context.colorScheme.surface,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
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
                        _taglineField(),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                              if (formKey.currentState?.validate() ?? false) {
                                context.read<StoreBloc>().add(
                                      CreateStoreEvent(
                                        country: countryController.text,
                                        storeName: storeNameController.text,
                                        webAddress: webAddressController.text,
                                        description: descriptionController.text,
                                        storeType: storeTypeController.text,
                                        address: addressLine1Controller.text,
                                        city: cityController.text,
                                        courierName: courierNameController.text,
                                        tagLine: taglineController.text,
                                      ),
                                    );
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
                              text: S.current.storeCreateButton,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

  Widget _taglineField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            S.current.storeTaglineLabel,
            style: const TextStyle(
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
                  // Text(
                  //   _taglineController.text,
                  //   style: const TextStyle(fontSize: 12),
                  // ),
                  const SizedBox(width: 4),
                  InkWell(
                    // onTap: () {
                    //   _taglineController.clear();
                    // },
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
