import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/utils/validators.dart';
import 'package:laza/presentations/pages/auth/widgets/form.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/buttons.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/layout/scaffold.dart';
import 'package:laza/presentations/widgets/indicator.dart';
import 'package:laza/presentations/widgets/snack_bar.dart';
import 'package:laza/providers/auth_provider.dart';
import 'widgets/text_input.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final formValidationProvider = StateProvider<bool>((ref) => false);

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void forgotPassword() {
    LSLoadingIndicator.show(context);
    ref
        .read(authRepositoryProvider)
        .forgotPassword(emailController.text)
        .then((_) {
      LSLoadingIndicator.hide(context);
    }).catchError((e) {
      LSLoadingIndicator.hide(context);
      LSSnackBar.buildErrorSnackbar(
        context,
        e.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = ref.watch(formValidationProvider);

    return LazaShopScaffold(
      body: Column(
        children: [
          SizedBox(height: 45.h),
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
          SizedBox(height: 55.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LSForm(
              isValidated: (isValid) {
                ref.read(formValidationProvider.notifier).state = isValid;
              },
              textFields: [
                TextInput(
                  labelText: S.current.email,
                  controller: emailController,
                  validatorText: (value) =>
                      InputValidationMixin.validEmail(value ?? ''),
                ),
              ],
            ),
          ),
          SizedBox(height: 55.h),
          LSButton(
            isDisabled: !isFormValid,
            text: S.current.sendEmail,
            onPressed: forgotPassword,
          ),
        ],
      ),
    );
  }
}
