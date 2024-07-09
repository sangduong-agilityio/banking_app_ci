import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extenssions/context_extenssions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/core/widgets/app_bar.dart';
import 'package:laza/core/widgets/buttons.dart';
import 'package:laza/core/widgets/icons.dart';
import 'package:laza/core/widgets/scaffold.dart';
import 'package:laza/features/auth/presentation/widgets/text_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
            style: context.textTheme.headlineMedium!
                .copyWith(color: context.colorScheme.tertiaryContainer),
          ),
          const SizedBox(height: 55),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextInput(
              labelText: S.current.email,
            ),
          ),
          const SizedBox(height: 55),
          LSButton(
              text: S.current.sendEmail,
              onPressed: () {
                context.pushNamed(AppRoutesName.signInScreen.name);
              })
        ],
      ),
    );
  }
}
