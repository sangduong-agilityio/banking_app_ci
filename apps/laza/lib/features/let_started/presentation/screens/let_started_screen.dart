import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extenssions/context_extenssions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/core/widgets/app_bar.dart';
import 'package:laza/core/widgets/buttons.dart';
import 'package:laza/core/widgets/icons.dart';
import 'package:laza/core/widgets/scaffold.dart';
import 'package:laza/features/let_started/presentation/widgets/social_button.dart';

class LetStartedScreen extends StatelessWidget {
  const LetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const sizedBox107 = SizedBox(height: 107);
    const sizeBox10 = SizedBox(height: 10);
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
          const SizedBox(height: 65),
          Center(
            child: Text(
              S.current.letGetStarted,
              style: context.textTheme.displayLarge,
            ),
          ),
          sizedBox107,
          const _SocialButtons(sizeBox10: sizeBox10),
          sizedBox107,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: S.current.alreadyAccount,
                  style: context.textTheme.headlineMedium!
                      .copyWith(color: context.colorScheme.tertiaryContainer),
                ),
                TextSpan(
                  text: S.current.signInTextBtn,
                  style: context.textTheme.headlineLarge?.copyWith(
                    color: context.colorScheme.primaryContainer,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.pushNamed(AppRoutesName.signInScreen.name);
                    },
                )
              ],
            ),
          ),
          sizedBox107,
          LSButton(
              text: S.current.createAccountBtn,
              onPressed: () {
                context.pushNamed(AppRoutesName.signUpScreen.name);
              })
        ],
      ),
    );
  }
}

class _SocialButtons extends StatelessWidget {
  const _SocialButtons({
    required this.sizeBox10,
  });

  final SizedBox sizeBox10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          LSSocialButton(
            text: S.current.facebookBtn,
            onPressed: () {},
            color: context.colorScheme.onPrimaryContainer,
            icon: LSIcons.icFacebook,
          ),
          sizeBox10,
          LSSocialButton(
            text: S.current.twitterBtn,
            onPressed: () {},
            color: context.colorScheme.onSurfaceVariant,
            icon: LSIcons.icTwitter,
          ),
          sizeBox10,
          LSSocialButton(
            text: S.current.googleBtn,
            onPressed: () {},
            color: context.colorScheme.error,
            icon: LSIcons.icGoogle,
          ),
        ],
      ),
    );
  }
}
