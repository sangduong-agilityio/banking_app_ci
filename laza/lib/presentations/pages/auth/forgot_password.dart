import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/core/utils/validators.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/buttons.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/layout/scaffold.dart';
import 'widgets/text_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

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
          const SizedBox(height: 55),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextInput(
              labelText: S.current.email,
              controller: emailController,
              validatorText: (value) =>
                  InputValidationMixin.validEmail(value ?? ''),
            ),
          ),
          const SizedBox(height: 55),
          LSButton(
              text: S.current.sendEmail,
              onPressed: () {
                context.pushNamed(AppRoutesName.signInPage.name);
              })
        ],
      ),
    );
  }
}
