import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/core/utils/validators.dart';
import 'package:laza/presentations/layout/scaffold.dart';
import 'package:laza/presentations/pages/auth/widgets/form.dart';
import 'package:laza/presentations/pages/auth/widgets/text_input.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/buttons.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/widgets/indicator.dart';
import 'package:laza/presentations/widgets/snack_bar.dart';
import 'package:laza/providers/auth_provider.dart';

class PasswordResetPage extends ConsumerStatefulWidget {
  const PasswordResetPage({super.key});

  @override
  ConsumerState<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends ConsumerState<PasswordResetPage> {
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final formValidationProvider = StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {
    final isFormValid = ref.watch(formValidationProvider);

    void resetPassword() {
      LSLoadingIndicator.show(context);
      ref
          .read(authRepositoryProvider)
          .resetPassword(
            passwordController.text,
          )
          .then((_) {
        LSLoadingIndicator.hide(context);
        context.pushNamed(AppRoutesName.signInPage.name);
      }).catchError((e) {
        LSLoadingIndicator.hide(context);
        LSSnackBar.buildErrorSnackbar(
          context,
          e.toString(),
        );
      });
    }

    return LazaShopScaffold(
      body: Column(
        children: [
          SizedBox(height: 25.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LSAppBar(
              onTappedBackButton: () => context.pop(),
              icon: LSIcons.icArrowLeft,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            S.current.resetPassword,
            style: context.textTheme.displayLarge,
          ),
          const SizedBox(height: 5),
          Text(
            S.current.pleaseEnterYourPasswordReset,
            style: context.textTheme.headlineSmall!
                .copyWith(color: context.colorScheme.tertiaryContainer),
          ),
          SizedBox(height: 55.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              LSForm(
                spaceBetweenRow: 20,
                isValidated: (isValid) {
                  ref.read(formValidationProvider.notifier).state = isValid;
                },
                textFields: [
                  TextInput(
                    labelText: S.current.password,
                    controller: passwordController,
                    hasObscureText: true,
                    validatorText: (value) =>
                        InputValidationMixin.validPassword(value ?? ''),
                  ),
                  TextInput(
                    labelText: S.current.confirmPassword,
                    controller: passwordConfirmController,
                    hasObscureText: true,
                    validatorText: (value) =>
                        InputValidationMixin.validConfirmation(
                      needConfirm: value ?? '',
                      confirm: passwordController.text,
                    ),
                  ),
                ],
              ),
            ]),
          ),
          SizedBox(height: 55.h),
          LSButton(
              isDisabled: !isFormValid,
              text: S.current.resetPassword,
              onPressed: resetPassword),
        ],
      ),
    );
  }
}
