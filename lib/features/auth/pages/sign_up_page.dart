import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/validators.dart';
import 'package:banking_app/features/auth/widgets/animated_floating_dot.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emaiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emaiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      backgroundColor: context.colorScheme.primary,
      appBar: BAAppBar(
        title: S.current.signUpTitle,
        alignment: BAAppBarAlignment.left,
        titleColor: context.colorScheme.onPrimary,
        iconColor: context.colorScheme.onPrimary,
        backgroundColor: context.colorScheme.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.onPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                    child: BAForm(
                      formKey: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.current.signUpWelcomeTitle,
                            style: context.displaySmall?.copyWith(
                              color: context.colorScheme.secondary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            S.current.signUpDescription,
                            style: context.labelMedium?.copyWith(
                              color: context.colorScheme.onInverseSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 32),
                          AnimatedDot(),
                          UsernameInput(
                            hint: S.current.validatorNameRequired,
                            validators: [
                              (value) => value != null
                                  ? InputValidationMixin.validUserName(value)
                                  : 'User name is required',
                            ],
                          ),
                          const SizedBox(height: 20),

                          EmailInput(
                            hint: S.current.signInEmailHint,
                            validators: [
                              (value) => value != null
                                  ? InputValidationMixin.validEmail(value)
                                  : 'Email is required',
                            ],
                          ),
                          const SizedBox(height: 20),
                          PasswordInput(hint: S.current.signInPassowrdHint),
                          SizedBox(height: 40),
                          Text(
                            S.current.signUpTermAndConditions,
                            style: context.bodySmall,
                          ),
                          SizedBox(height: 40),
                          BAElevatedButton(
                            text: S.current.signUpButton,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState?.save();
                              }
                            },
                          ),
                          SizedBox(height: 14),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: S.current.signUpAlreadyAcccount,
                                style: context.bodySmall,
                                children: [
                                  TextSpan(
                                    text: 'Sign In',
                                    style: context.bodySmall?.copyWith(
                                      color: context.colorScheme.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
