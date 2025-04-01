import 'package:flutter/material.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/form.dart';
import 'package:tradly_app/widgets/input.dart';
import 'package:tradly_app/widgets/text.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: context.colorScheme.primary,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
              SizedBox(height: 45),
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
                fontWeight: FontWeight.w600,
                text: S.current.signInLoginButton,
                textSize: 16,
                textColor: context.colorScheme.primary,
                backgroundColor: context.colorScheme.onPrimary,
                onPressed: () {},
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: Text(
                  S.current.signInForgotPassword,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: Text(
                  S.current.signInSignUpPrompt,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
