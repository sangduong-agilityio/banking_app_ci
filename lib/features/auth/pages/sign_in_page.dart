import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/validators.dart';
import 'package:banking_app/features/auth/widgets/animated_floating_dot.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/widgets/auth_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emaiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  @override
  void dispose() {
    _emaiController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      backgroundColor: context.colorScheme.primary,
      appBar: BAAppBar(
        title: S.current.signInTitle,
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
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.colorScheme.onPrimary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 24,
                    ),
                    child: BAForm(
                      formKey: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.current.signInWelcomeTitle,
                            style: context.displaySmall?.copyWith(
                              color: context.colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            S.current.signInDescription,
                            style: context.labelMedium?.copyWith(
                              color: context.colorScheme.onInverseSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const AnimatedDot(),
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
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                S.current.signInForgotPassword,
                                style: context.bodySmall,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          BAElevatedButton(
                            text: S.current.signInButton,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState?.save();
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: S.current.signInSignUpPrompt,
                                style: context.bodySmall,
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.pushNamed(BAPaths.signUp.name);
                                      },
                                    text: S.current.signUpTitle,
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
