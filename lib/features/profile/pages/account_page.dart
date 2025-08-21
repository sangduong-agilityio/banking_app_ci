import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/widgets/auth_form.dart';
import 'package:banking_app/features/profile/widgets/card_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.accountTitle,
        titleColor: context.colorScheme.scrim,
        iconColor: context.colorScheme.scrim,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CreditCardDetail(),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  S.current.accountDetailInfoTitle,
                  style: context.labelMedium,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BAForm(
                  key: _formKey,
                  spaceBetweenRow: 10,
                  textFields: [
                    BATextField(label: S.current.accountNameLabel),
                    BATextField(label: S.current.accountPhoneNumberLabel),
                    BATextField(label: S.current.accountEmailLabel),
                    BATextField(label: S.current.accountHomeAddressLabel),
                  ],
                  isValidated: (value) => null,
                ),
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: BAElevatedButton(
                  height: 56,
                  text: S.current.accountSaveButton,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
