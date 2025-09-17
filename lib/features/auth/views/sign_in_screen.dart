import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/utils/pref_keys.dart';
import 'package:banking_app/core/utils/validators.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/widgets/auth_form.dart';
import 'package:banking_app/features/auth/states/auth_bloc.dart';
import 'package:banking_app/features/auth/states/auth_event.dart';
import 'package:banking_app/features/auth/states/auth_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = locator<AuthBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authBloc.add(const CheckBiometricAvailabilityEvt());
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          state.status.maybeWhen(
            loading: () => context.loaderOverlay.show(),
            success: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(
                PrefKeys.sessionToken,
                state.sessionToken ?? '',
              );
              if (context.mounted) context.pushNamed(BAPaths.home.name);
              if (context.mounted) context.loaderOverlay.hide();
            },
            failure: () {
              BASnackBar.buildErrorSnackbar(context, state.errorMessage ?? '');
              if (context.mounted) context.loaderOverlay.hide();
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
                  color: context.colorScheme.secondary,
                  child: Column(
                    children: [
                      BAAppBar(
                        title: S.current.signInTitle,
                        alignment: BAAppBarAlignment.left,
                        titleColor: context.colorScheme.onPrimary,
                        iconColor: context.colorScheme.onPrimary,
                        backgroundColor: context.colorScheme.secondary,
                      ),
                      SignInBody(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        isFormValid: state.isFormValid,
                        isBiometricAvailable: state.isBiometricAvailable,
                        isBiometricEnabled: state.isBiometricEnabled,
                        hasSavedBiometricCredentials:
                            state.hasSavedBiometricCredentials,
                        onBiometricPressed: () {
                          context.read<AuthBloc>().add(
                            const SignInWithBiometricEvt(),
                          );
                        },
                      ),
                    ],
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

class SignInBody extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isFormValid;
  final bool isBiometricAvailable;
  final bool isBiometricEnabled;
  final bool hasSavedBiometricCredentials;
  final VoidCallback onBiometricPressed;

  const SignInBody({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isFormValid,
    required this.isBiometricAvailable,
    required this.isBiometricEnabled,
    required this.hasSavedBiometricCredentials,
    required this.onBiometricPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colorScheme.onPrimary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthForm(
                title: S.current.signInWelcomeTitle,
                description: S.current.signInDescription,
                textFields: [
                  BATextField(
                    controller: emailController,
                    hint: S.current.signInEmailHint,
                    validator: (value) =>
                        InputValidationMixin.validEmail(value ?? ''),
                  ),
                  BATextField(
                    controller: passwordController,
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
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ),
                  );
                },
                onSubmit: () {
                  context.read<AuthBloc>().add(const SignInButtonPressedEvt());
                },
                submitText: S.current.signInButton,
                isSubmitEnabled: isFormValid,
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
                footer: Column(
                  children: [
                    if (isBiometricAvailable &&
                        isBiometricEnabled &&
                        hasSavedBiometricCredentials)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: GestureDetector(
                          onTap: onBiometricPressed,
                          child: Icon(
                            Icons.fingerprint,
                            color: context.colorScheme.secondary,
                            size: 64,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    RichText(
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
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
