import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/widgets/auth_form.dart';
import 'package:flutter/material.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.settingChangePasswordTitle,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BAForm(
                  isValidated: (value) => null,
                  textFields: [
                    BATextField(
                      label: S.current.settingRecentPasswordLabel,
                      hint: S.current.settingRecentPasswordLabel,
                    ),
                    BATextField(
                      label: S.current.settingNewPasswordLabel,
                      hint: S.current.settingNewPasswordLabel,
                    ),
                    BATextField(
                      label: S.current.settingConfirmPasswordLabel,
                      hint: S.current.settingConfirmPasswordLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                BAElevatedButton(
                  padding: EdgeInsets.zero,
                  text: S.current.settingChangePasswordTitle,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
