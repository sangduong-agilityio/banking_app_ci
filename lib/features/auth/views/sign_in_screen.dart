import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/validators.dart';
import 'package:banking_app/core/widgets/clipper.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/auth/states/auth_bloc.dart';
import 'package:banking_app/features/auth/states/auth_event.dart';
import 'package:banking_app/features/auth/states/auth_state.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/widgets/auth_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
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
            success: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('session_token', state.sessionToken ?? '');
              if (context.mounted) context.pushNamed(BAPaths.home.name);
              if (context.mounted) context.loaderOverlay.hide();
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
              body: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Container(
                  color: context.colorScheme.primary,
                  child: Column(
                    children: [
                      BAAppBar(
                        title: S.current.signInTitle,
                        alignment: BAAppBarAlignment.left,
                        titleColor: context.colorScheme.onPrimary,
                        iconColor: context.colorScheme.onPrimary,
                        backgroundColor: context.colorScheme.primary,
                      ),
                      AuthForm(
                        title: S.current.signInWelcomeTitle,
                        description: S.current.signInDescription,
                        textFields: [
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
                            SignInFormValidateChangedEvt(
                              isValidate: isValid,
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            ),
                          );
                        },
                        onSubmit: () {
                          context.read<AuthBloc>().add(
                            const SignInButtonPressedEvt(),
                          );
                        },
                        submitText: S.current.signInButton,
                        isSubmitEnabled: state.isFormValid,
                        extra: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              S.current.signInForgotPassword,
                              style: context.bodySmall,
                            ),
                          ),
                        ),
                        footer: RichText(
                          text: TextSpan(
                            text: S.current.signInSignUpPrompt,
                            style: context.bodySmall,
                            children: [
                              TextSpan(
                                text: S.current.signUpTitle,
                                style: context.bodySmall?.copyWith(
                                  color: context.colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      context.pushNamed(BAPaths.signUp.name),
                              ),
                            ],
                          ),
                        ),
                        height: SizedBox(height: 100),
                      ),
                    ],
                  ),
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
