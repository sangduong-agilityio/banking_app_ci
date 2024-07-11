import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/buttons.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/layout/scaffold.dart';
import 'widgets/text_input.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return LazaShopScaffold(
      body: Column(
        children: [
          const SizedBox(height: 45),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LSAppBar(
                onTappedBackButton: () => context.pop(),
                icon: LSIcons.icArrowLeft),
          ),
          const SizedBox(height: 15),
          const SignInForm(),
          const SizedBox(height: 20),
          LSButton(
              text: S.current.loginBtn,
              onPressed: () {
                context.pushNamed(AppRoutesName.homePage.name);
              })
        ],
      ),
    );
  }
}

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            S.current.welcome,
            style: context.textTheme.displayLarge,
          ),
          const SizedBox(height: 5),
          Text(
            S.current.pleaseEnterData,
            style: context.textTheme.headlineSmall!
                .copyWith(color: context.colorScheme.tertiaryContainer),
          ),
          const SizedBox(height: 165),
          TextInput(
            labelText: S.current.username,
          ),
          const SizedBox(height: 20),
          TextInput(
            labelText: S.current.password,
            hasObscureText: true,
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () {
              context.pushNamed(AppRoutesName.forgotPasswordPage.name);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                S.current.forgotPasswordTextBtn,
                style: context.textTheme.headlineMedium!
                    .copyWith(color: context.colorScheme.error),
              ),
            ),
          ),
          const SizedBox(height: 42),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.rememberMe,
                textAlign: TextAlign.left,
                style: context.textTheme.headlineLarge!
                    .copyWith(color: context.colorScheme.tertiary),
              ),
              CupertinoSwitch(
                value: true,
                onChanged: (bool val) {},
              ),
            ],
          ),
          const SizedBox(height: 110),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: S.current.connectingYourAccount,
                  style: context.textTheme.headlineSmall!
                      .copyWith(color: context.colorScheme.tertiaryContainer),
                ),
                TextSpan(
                  text: S.current.termAndCondition,
                  style: context.textTheme.headlineLarge?.copyWith(
                    color: context.colorScheme.primaryContainer,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                )
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
