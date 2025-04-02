import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/routes/app_router.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/form.dart';
import 'package:tradly_app/widgets/input.dart';
import 'package:tradly_app/widgets/text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: context.colorScheme.primary,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
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
                  isValidated: (isValidated) {},
                  spaceBetweenRow: 20,
                  textFields: [
                    TextInput(
                      textInputAction: TextInputAction.next,
                      labelText: S.current.signInEmailOrMobileLabel,
                      labelStyle:
                          TextStyle(color: context.colorScheme.onPrimary),
                    ),
                    TextInput(
                      labelText: S.current.signInPasswordLabel,
                      labelStyle:
                          TextStyle(color: context.colorScheme.onPrimary),
                    ),
                  ]),
              SizedBox(height: 38),
              TAElevatedButton(
                fontWeight: FontWeight.w500,
                text: S.current.signInLoginButton,
                textSize: 16,
                textColor: context.colorScheme.primary,
                backgroundColor: context.colorScheme.onPrimary,
                onPressed: () {},
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
    );
  }
}
