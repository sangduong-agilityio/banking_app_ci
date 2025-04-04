import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/routes/app_router.dart';
import 'package:tradly_app/screens/auth/states/sign_in_bloc.dart';
import 'package:tradly_app/screens/auth/states/sign_in_event.dart';
import 'package:tradly_app/screens/auth/states/sign_in_state.dart';
import 'package:tradly_app/utils/enumeration.dart';
import 'package:tradly_app/utils/validators.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/form.dart';
import 'package:tradly_app/widgets/indicator.dart';
import 'package:tradly_app/widgets/input.dart';
import 'package:tradly_app/widgets/snackbar.dart';
import 'package:tradly_app/widgets/text.dart';
import 'package:tradly_app/repositories/auth_repo.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocProvider(
        create: (context) => SignInBloc(
          authRepository: AuthRepositoryImplement(
            Supabase.instance.client,
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: context.colorScheme.primary,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TaDisplaySmallText(
                    text: S.current.signInWelcomeTitle,
                  ),
                  const SizedBox(height: 66),
                  TaHeadlineSmallText(
                    text: S.current.signInLoginPrompt,
                  ),
                  const SizedBox(height: 25),
                  BlocBuilder<SignInBloc, SignInState>(
                    buildWhen: (previous, current) =>
                        previous.viewState != current.viewState,
                    builder: (context, state) => TAForm(
                      isValidated: (valid) => context.read<SignInBloc>().add(
                            SignInFormValidateChangedEvt(
                              isValidate: valid,
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          ),
                      spaceBetweenRow: 20,
                      textFields: [
                        TextInput(
                          controller: _emailController,
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
                          hasObscureText: true,
                          validatorText: (value) =>
                              InputValidationMixin.validPassword(value ?? ''),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 38),
                  BlocConsumer<SignInBloc, SignInState>(
                    listenWhen: (previous, current) =>
                        previous.viewState != current.viewState,
                    listener: (context, state) {
                      if (state.viewState == SubmissionStatus.loading) {
                        LALoadingIndicator.show(context);
                      } else if (state.viewState ==
                          SubmissionStatus.successful) {
                        LALoadingIndicator.hide(context);
                        context.pushNamed(TAPaths.home.name);
                      } else if (state.viewState == SubmissionStatus.failed) {
                        LALoadingIndicator.hide(context);
                        LASnackBar.buildErrorSnackbar(
                          context,
                          state.errorMessage ?? '',
                        );
                      }
                    },
                    builder: (context, state) => TAElevatedButton(
                      isDisabled: !state.isFormValid,
                      fontWeight: FontWeight.w500,
                      text: S.current.signInLoginButton,
                      textSize: 16,
                      textColor: context.colorScheme.primary,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context
                              .read<SignInBloc>()
                              .add(SignInButtonPressedEvt());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    child: TaHeadlineMediumText(
                      text: S.current.signInForgotPassword,
                    ),
                  ),
                  const SizedBox(height: 45),
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
    );
  }
}
