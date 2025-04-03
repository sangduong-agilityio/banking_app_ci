import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/repositories/auth_repo.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/routes/app_router.dart';
import 'package:tradly_app/utils/validators.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/form.dart';
import 'package:tradly_app/widgets/input.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'states/sign_up_bloc.dart';
import 'states/sign_up_event.dart';
import 'states/sign_up_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reEnterPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _reEnterPasswordController.dispose();
    super.dispose();
  }

  void _updateFormValidity(bool isValid) {
    setState(() {
      _isFormValid = isValid;
    });
    context.read<SignUpBloc>().add(SignUpFormValidateChanged(isValid: isValid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(
          authRepository: AuthRepositoryImplement(Supabase.instance.client)),
      child: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            context.pushNamed(TAPaths.sendOTP.name);
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: context.colorScheme.primary,
            appBar: TaAppBar(
              toolbarHeight: TaAppBarSize.small,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TaDisplaySmallText(
                      text: S.current.signUpWelcomeTitle,
                    ),
                    SizedBox(height: 66),
                    TaHeadlineSmallText(
                      text: S.current.signUpTitle,
                    ),
                    SizedBox(height: 25),
                    TAForm(
                      isValidated: _updateFormValidity,
                      spaceBetweenRow: 20,
                      textFields: [
                        TextInput(
                          controller: _firstNameController,
                          textInputAction: TextInputAction.next,
                          labelText: S.current.signUpFirstNameLabel,
                          labelStyle:
                              TextStyle(color: context.colorScheme.onPrimary),
                          validatorText: (value) =>
                              InputValidationMixin.validFirstName(value ?? ''),
                        ),
                        TextInput(
                          controller: _lastNameController,
                          textInputAction: TextInputAction.next,
                          labelText: S.current.signUpLastNameLabel,
                          labelStyle:
                              TextStyle(color: context.colorScheme.onPrimary),
                          validatorText: (value) =>
                              InputValidationMixin.validLastName(value ?? ''),
                        ),
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
                        TextInput(
                          controller: _reEnterPasswordController,
                          labelText: S.current.signUpReEnterPasswordLabel,
                          labelStyle:
                              TextStyle(color: context.colorScheme.onPrimary),
                          validatorText: (value) =>
                              InputValidationMixin.validReEnterPassword(
                            password: _passwordController.text,
                            reEnterPassword: value ?? '',
                          ),
                          hasObscureText: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 38),
                    TAElevatedButton(
                      fontWeight: FontWeight.w500,
                      text: S.current.signUpCreateButton,
                      textSize: 16,
                      textColor: context.colorScheme.primary,
                      backgroundColor: _isFormValid
                          ? context.colorScheme.onPrimary
                          : context.colorScheme.onSecondary,
                      onPressed: _isFormValid
                          ? () {
                              if (_formKey.currentState?.validate() ?? false) {
                                debugPrint(
                                    'Form is valid. Dispatching SignUpSubmitted event.');
                                context.read<SignUpBloc>().add(
                                      SignUpSubmitted(
                                        email: _emailOrPhoneController.text,
                                        password: _passwordController.text,
                                        username:
                                            '${_firstNameController.text} ${_lastNameController.text}',
                                      ),
                                    );
                              } else {
                                debugPrint('Form is invalid.');
                              }
                            }
                          : () {
                              debugPrint(
                                  'Button is disabled because form is invalid.');
                            },
                    ),
                    SizedBox(height: 38),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: RichText(
                        text: TextSpan(
                          text: S.current.signUpAlreadyAcccount,
                          style: context.textTheme.headlineMedium?.copyWith(
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text: S.current.signInButton,
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
