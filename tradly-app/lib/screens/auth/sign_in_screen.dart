import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/routes/app_router.dart';
import 'package:tradly_app/utils/validators.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/form.dart';
import 'package:tradly_app/widgets/indicator.dart';
import 'package:tradly_app/widgets/input.dart';
import 'package:tradly_app/widgets/snackbar.dart';
import 'package:tradly_app/widgets/text.dart';
import 'package:tradly_app/repositories/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'states/sign_in_bloc.dart';
import 'states/sign_in_event.dart';
import 'states/sign_in_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  void _updateFormValidity() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(
        authRepository: AuthRepositoryImplement(
          Supabase.instance.client,
        ),
      ),
      child: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInLoading) {
            LALoadingIndicator.show(context);
          } else if (state is SignInSuccess) {
            LALoadingIndicator.hide(context);
            context.goNamed(TAPaths.home.name);
          } else if (state is SignInFailure) {
            LALoadingIndicator.hide(context);
            LASnackBar.buildErrorSnackbar(
              context,
              state.error,
            );
          }
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: context.colorScheme.primary,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                onChanged: _updateFormValidity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TaDisplaySmallText(
                      text: S.current.signInWelcomeTitle,
                    ),
                    SizedBox(height: 66),
                    TaHeadlineSmallText(
                      text: S.current.signInLoginPrompt,
                    ),
                    SizedBox(height: 25),
                    TAForm(
                      spaceBetweenRow: 20,
                      isValidated: (isValid) {
                        setState(() {
                          _isFormValid = isValid;
                        });
                      },
                      textFields: [
                        TextInput(
                          controller: _emailOrPhoneController,
                          textInputAction: TextInputAction.next,
                          labelText: S.current.signInEmailOrMobileLabel,
                          labelStyle:
                              TextStyle(color: context.colorScheme.onPrimary),
                          validatorText: (value) =>
                              InputValidationMixin.validEmailOrPhone(
                                  value ?? ''),
                        ),
                        TextInput(
                          controller: _passwordController,
                          labelText: S.current.signInPasswordLabel,
                          labelStyle:
                              TextStyle(color: context.colorScheme.onPrimary),
                          validatorText: (value) =>
                              InputValidationMixin.validPassword(value ?? ''),
                          hasObscureText: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 38),
                    TAElevatedButton(
                      fontWeight: FontWeight.w500,
                      text: S.current.signInLoginButton,
                      textSize: 16,
                      textColor: context.colorScheme.primary,
                      backgroundColor: _isFormValid
                          ? context.colorScheme.onPrimary
                          : context.colorScheme.onSurface.withOpacity(0.5),
                      onPressed: _isFormValid
                          ? () {
                              context.read<SignInBloc>().add(
                                    SignInButtonPressed(
                                      email: _emailOrPhoneController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            }
                          : null,
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
                      child: TaHeadlineMediumText(
                        text: S.current.signInForgotPassword,
                      ),
                    ),
                    SizedBox(height: 45),
                    TextButton(
                      onPressed: () {
                        context.pushNamed(TAPaths.signUp.name);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: S.current.signInSignUpPrompt,
                          style: context.textTheme.headlineMedium?.copyWith(
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text: S.current.signUpButton,
                              style: context.textTheme.headlineMedium?.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
