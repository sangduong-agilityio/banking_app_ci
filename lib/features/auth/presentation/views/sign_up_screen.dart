import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/security/input_validator.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:banking_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:banking_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// A screen for user sign-up.
///
/// This screen provides a form for new users to create an account.
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
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state.status) {
            case AuthStatus.loading:
              context.loaderOverlay.show();
              break;
            case AuthStatus.success:
              context.loaderOverlay.hide();
              context.pop();
              break;
            case AuthStatus.failure:
              context.loaderOverlay.hide();
              BASnackBar.buildErrorSnackbar(context, state.errorMessage ?? '');
              break;
            case AuthStatus.initial:
              context.loaderOverlay.hide();
              break;
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) =>
              previous.isFormValid != current.isFormValid ||
              previous.isTermsAccepted != current.isTermsAccepted,
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
                          title: S.current.signUpTitle,
                          alignment: BAAppBarAlignment.left,
                          titleColor: context.colorScheme.onPrimary,
                          iconColor: context.colorScheme.onPrimary,
                          backgroundColor: context.colorScheme.secondary,
                        ),
                        SignUpBody(
                          usernameController: _usernameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          isFormValid: state.isFormValid,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The main body of the sign-up screen.
///
/// This widget contains the sign-up form and the link to the sign-in screen.
class SignUpBody extends StatelessWidget {
  const SignUpBody({
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.isFormValid,
    super.key,
  });

  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isFormValid;

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
          child: AuthForm(
            title: S.current.signUpWelcomeTitle,
            description: S.current.signUpDescription,
            textFields: _buildTextFields(),
            onValidate: (isValid) {
              context.read<AuthBloc>().add(
                    SignUpFormValidateChanged(
                      isValidate: isValid,
                      username: usernameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ),
                  );
            },
            onSubmit: () {
              context.read<AuthBloc>().add(SignUpButtonPressed());
            },
            submitText: S.current.signUpButton,
            isSubmitEnabled:
                isFormValid &&
                context.select((AuthBloc bloc) => bloc.state.isTermsAccepted),
            showTerms: true,
            isTermsAccepted: context.select(
              (AuthBloc bloc) => bloc.state.isTermsAccepted,
            ),
            onTermsChanged: (value) {
              context.read<AuthBloc>().add(
                    SignUpTermsChanged(isAccepted: value ?? false),
                  );
            },
            footer: _buildFooter(context),
          ),
        ),
      ),
    );
  }

  /// Builds the text fields for the sign-up form.
  List<Widget> _buildTextFields() {
    return [
      BATextField(
        controller: usernameController,
        hint: S.current.validatorNameRequired,
        validator: (value) => SecureInputValidator.validateSecureInput(
          value,
          fieldName: S.current.validatorNameRequired,
          minLength: 2,
          maxLength: 50,
          allowSpecialChars: false,
        ),
      ),
      BATextField(
        controller: emailController,
        hint: S.current.signInEmailHint,
        validator: SecureInputValidator.validateEmail,
      ),
      BATextField(
        controller: passwordController,
        hint: S.current.signInPassowrdHint,
        isPassword: true,
        validator: SecureInputValidator.validatePassword,
      ),
    ];
  }

  /// Builds the footer of the sign-up form, including the link to the sign-in screen.
  Widget _buildFooter(BuildContext context) {
    return RichText(
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
            recognizer: TapGestureRecognizer()..onTap = () => context.pop(),
          ),
        ],
      ),
    );
  }
}
