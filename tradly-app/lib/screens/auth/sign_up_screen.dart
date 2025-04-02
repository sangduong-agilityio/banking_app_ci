import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/routes/app_router.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/form.dart';
import 'package:tradly_app/widgets/input.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  isValidated: (isValidated) {},
                  spaceBetweenRow: 20,
                  textFields: [
                    TextInput(
                      textInputAction: TextInputAction.next,
                      labelText: S.current.signUpFirstNameLabel,
                      labelStyle:
                          TextStyle(color: context.colorScheme.onPrimary),
                    ),
                    TextInput(
                      textInputAction: TextInputAction.next,
                      labelText: S.current.signUpLastNameLabel,
                      labelStyle:
                          TextStyle(color: context.colorScheme.onPrimary),
                    ),
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
                    TextInput(
                      labelText: S.current.signUpReEnterPasswordLabel,
                      labelStyle:
                          TextStyle(color: context.colorScheme.onPrimary),
                    ),
                  ]),
              SizedBox(height: 38),
              TAElevatedButton(
                fontWeight: FontWeight.w500,
                text: S.current.signUpCreateButton,
                textSize: 16,
                textColor: context.colorScheme.primary,
                backgroundColor: context.colorScheme.onPrimary,
                onPressed: () {
                  context.pushNamed(TAPaths.sendOTP.name);
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
    );
  }
}
