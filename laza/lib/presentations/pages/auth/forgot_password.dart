import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/utils/validators.dart';
import 'package:laza/data/repositories/auth_repo.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/buttons.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/layout/scaffold.dart';
import 'package:laza/presentations/widgets/indicator.dart';
import 'package:laza/presentations/widgets/snack_bar.dart';
import 'widgets/text_input.dart';

class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();

    Future<void> _forgotPassword() async {
      try {
        LSLoadingIndicator.show(context);
        await ref
            .read(authRepositoryProvider)
            .forgotPassword(emailController.text);
        if (context.mounted) {
          LSLoadingIndicator.hide(context);
        }
      } catch (e) {
        LSLoadingIndicator.hide(context);
        LSSnackBar.buildErrorSnackbar(
          context,
          e.toString(),
        );
      }
    }

    return LazaShopScaffold(
      body: Column(
        children: [
          const SizedBox(height: 45),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LSAppBar(
              onTappedBackButton: () => context.pop(),
              icon: LSIcons.icArrowLeft,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            S.current.forgotPassword,
            style: context.textTheme.displayLarge,
          ),
          const SizedBox(height: 5),
          Text(
            S.current.pleaseEnterYourEmail,
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
            onPressed: _forgotPassword,
          )
        ],
      ),
    );
  }
}
