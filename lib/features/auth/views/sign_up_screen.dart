import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/validators.dart';
import 'package:banking_app/core/widgets/clipper.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/bloc/auth_bloc.dart';
import 'package:banking_app/features/auth/bloc/auth_event.dart';
import 'package:banking_app/features/auth/bloc/auth_state.dart';
import 'package:banking_app/features/auth/widgets/auth_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.status.maybeWhen(
            loading: () => context.loaderOverlay.show(),
            success: () {
              context.loaderOverlay.hide();
              context.pop();
            },
            failure: () {
              context.loaderOverlay.hide();
              BASnackBar.buildErrorSnackbar(context, state.errorMessage ?? '');
            },
            orElse: () => context.loaderOverlay.hide(),
          );
        },
        builder: (context, state) {
          return LoaderOverlay(
            child: BAScaffold(
              body: Container(
                color: context.colorScheme.primary,
                child: Column(
                  children: [
                    BAAppBar(
                      title: S.current.signUpTitle,
                      alignment: BAAppBarAlignment.left,
                      titleColor: context.colorScheme.onPrimary,
                      iconColor: context.colorScheme.onPrimary,
                      backgroundColor: context.colorScheme.primary,
                    ),
                    AuthForm(
                      title: S.current.signUpWelcomeTitle,
                      description: S.current.signUpDescription,
                      textFields: [
                        BATextField(
                          controller: _usernameController,
                          hint: S.current.validatorNameRequired,
                          validator: (value) =>
                              InputValidationMixin.validUserName(value ?? ''),
                        ),
                        BATextField(
                          controller: _emailController,
                          hint: S.current.signInEmailHint,
                          validator: (value) =>
                              InputValidationMixin.validEmail(value ?? ''),
                        ),
                        BATextField(
                          controller: _passwordController,
                          hint: S.current.signInPassowrdHint,
                          isPassword: true,
                          validator: (value) =>
                              InputValidationMixin.validPassword(value ?? ''),
                        ),
                      ],
                      onValidate: (isValid) {
                        context.read<AuthBloc>().add(
                          SignUpFormValidateChangedEvt(
                            isValidate: isValid,
                            username: _usernameController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ),
                        );
                      },
                      onSubmit: () {
                        context.read<AuthBloc>().add(
                          const SignUpButtonPressedEvt(),
                        );
                      },
                      submitText: S.current.signUpButton,
                      isSubmitEnabled:
                          state.isFormValid && state.isTermsAccepted,
                      showTerms: true,
                      isTermsAccepted: state.isTermsAccepted,
                      onTermsChanged: (value) {
                        context.read<AuthBloc>().add(
                          SignUpTermsChangedEvt(isAccepted: value ?? false),
                        );
                      },
                      footer: RichText(
                        text: TextSpan(
                          text: S.current.signUpAlreadyAcccount,
                          style: context.bodySmall,
                          children: [
                            TextSpan(
                              text: S.current.signInTitle,
                              style: context.bodySmall?.copyWith(
                                color: context.colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.pop(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: ClipPath(
                clipper: WaveClipper(flip: true, reverse: true),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: BAAppColors.primaryGradient,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
