import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/validators.dart';
import 'package:banking_app/core/widgets/clipper.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/auth/bloc/auth_bloc.dart';
import 'package:banking_app/features/auth/bloc/auth_event.dart';
import 'package:banking_app/features/auth/bloc/auth_state.dart';
import 'package:banking_app/features/auth/widgets/animated_floating_dot.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/widgets/auth_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emaiController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emaiController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.status.maybeWhen(
            loading: () => context.loaderOverlay.show(),
            success: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('session_token', state.sessionToken ?? '');
              if (context.mounted) {
                await context.pushNamed(BAPaths.home.name);
              }
              if (context.mounted) {
                context.loaderOverlay.hide();
              }
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
                  child: Column(
                    children: [
                      BAAppBar(
                        title: S.current.signInTitle,
                        titleColor: context.colorScheme.onPrimary,
                        alignment: BAAppBarAlignment.left,
                        iconColor: context.colorScheme.onPrimary,
                        backgroundColor: context.colorScheme.primary,
                      ),
                      AuthForm(
                        formKey: _formKey,
                        emaiController: _emaiController,
                        passwordController: _passwordController,
                      ),
                    ],
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
    required GlobalKey<FormBuilderState> formKey,
    required TextEditingController emaiController,
    required TextEditingController passwordController,
  }) : _formKey = formKey,
       _emaiController = emaiController,
       _passwordController = passwordController;

  final GlobalKey<FormBuilderState> _formKey;
  final TextEditingController _emaiController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                const SizedBox(height: 20),
                const AnimatedDot(),
                const SizedBox(height: 20),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return BAForm(
                      key: _formKey,
                      isValidated: (isValid) {
                        context.read<AuthBloc>().add(
                          SignInFormValidateChangedEvt(
                            isValidate: isValid,
                            email: _emaiController.text.trim(),
                            password: _passwordController.text.trim(),
                          ),
                        );
                      },
                      textFields: [
                        EmailInput(
                          controller: _emaiController,
                          hint: S.current.signInEmailHint,
                          validator: (value) =>
                              InputValidationMixin.validEmail(value ?? ''),
                        ),
                        PasswordInput(
                          controller: _passwordController,
                          hint: S.current.signInPassowrdHint,
                          validator: (value) =>
                              InputValidationMixin.validPassword(value ?? ''),
                        ),
                      ],
                    );
                  },
                ),
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
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return BAElevatedButton(
                      padding: EdgeInsets.zero,
                      isDisabled: !state.isFormValid,
                      text: S.current.signInButton,
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          const SignInButtonPressedEvt(),
                        );
                      },
                    );
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

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
