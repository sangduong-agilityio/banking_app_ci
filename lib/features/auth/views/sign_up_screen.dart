import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/validators.dart';
import 'package:banking_app/core/widgets/clipper.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/bloc/auth_bloc.dart';
import 'package:banking_app/features/auth/bloc/auth_event.dart';
import 'package:banking_app/features/auth/bloc/auth_state.dart';
import 'package:banking_app/features/auth/widgets/animated_floating_dot.dart';
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
  final _formKey = GlobalKey<FormState>();
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
    return BlocProvider<AuthBloc>(
      create: (context) => locator<AuthBloc>(),
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
          return BAScaffold(
            body: LoaderOverlay(
              child: Container(
                color: context.colorScheme.primary,
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: SafeArea(
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
                          formKey: _formKey,
                          usernameController: _usernameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                      ],
                    ),
                  ),
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
          );
        },
      ),
    );
  }
}

class AuthForm extends StatelessWidget {
  const AuthForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController usernameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) : _formKey = formKey,
       _usernameController = usernameController,
       _emailController = emailController,
       _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _usernameController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: context.colorScheme.onPrimary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.signUpWelcomeTitle,
                  style: context.displaySmall?.copyWith(
                    color: context.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  S.current.signUpDescription,
                  style: context.labelMedium?.copyWith(
                    color: context.colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                const AnimatedDot(),
                BAForm(
                  key: _formKey,
                  isValidated: (isValid) {
                    context.read<AuthBloc>().add(
                      SignUpFormValidateChangedEvt(
                        isValidate: isValid,
                        username: _usernameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    );
                  },
                  textFields: [
                    UsernameInput(
                      controller: _usernameController,
                      hint: S.current.validatorNameRequired,
                      validator: (value) =>
                          InputValidationMixin.validUserName(value ?? ''),
                    ),
                    EmailInput(
                      controller: _emailController,
                      hint: S.current.signInEmailHint,
                      validator: (value) =>
                          InputValidationMixin.validEmail(value ?? ''),
                    ),
                    PasswordInput(
                      hint: S.current.signInPassowrdHint,
                      controller: _passwordController,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Checkbox(
                      value: context.select(
                        (AuthBloc bloc) => bloc.state.isTermsAccepted,
                      ),
                      onChanged: (value) {
                        context.read<AuthBloc>().add(
                          SignUpTermsChangedEvt(isAccepted: value ?? false),
                        );
                      },
                    ),
                    Expanded(
                      child: Text(
                        S.current.signUpTermAndConditions,
                        style: context.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return BAElevatedButton(
                      padding: EdgeInsets.zero,
                      isDisabled: !state.isFormValid || !state.isTermsAccepted,
                      text: S.current.signUpButton,
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          const SignUpButtonPressedEvt(),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 14),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: S.current.signUpAlreadyAcccount,
                      style: context.bodySmall,
                      children: [
                        TextSpan(
                          text: ' ${S.current.signInTitle}',
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
