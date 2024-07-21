import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
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

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final isFormValidProvider = StateProvider<bool>((ref) => false);
    final isFormValid = ref.watch(isFormValidProvider);

    void login() {
      LSLoadingIndicator.show(context);
      ref
          .read(authRepositoryProvider)
          .signIn(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((_) {
        LSLoadingIndicator.hide(context);
        context.pushNamed(AppRoutesName.homePage.name);
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
          SignInForm(
            emailController: emailController,
            passwordController: passwordController,
            onFormValidationChanged: (isValid) {
              ref.read(isFormValidProvider.notifier).state = isValid;
            },
          ),
          const SizedBox(height: 20),
          LSButton(
            isDisabled: !isFormValid,
            text: S.current.loginBtn,
            onPressed: () => login(),
          ),
        ],
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function(bool isValid)? onFormValidationChanged;

  const SignInForm({
    required this.emailController,
    required this.passwordController,
    this.onFormValidationChanged,
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
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
          SizedBox(height: 165.h),
          LSForm(
            isValidated: (value) {
              widget.onFormValidationChanged?.call(value);
            },
            textFields: [
              TextInput(
                labelText: S.current.email,
                controller: widget.emailController,
                validatorText: (value) =>
                    InputValidationMixin.validEmail(value ?? ''),
              ),
              TextInput(
                labelText: S.current.password,
                controller: widget.passwordController,
                validatorText: (value) =>
                    InputValidationMixin.validPassword(value ?? ''),
                hasObscureText: true,
              ),
            ],
          ),
          SizedBox(height: 30.h),
          TextButton(
            onPressed: () {
              context.pushNamed(AppRoutesName.forgotPasswordPage.name);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                S.current.forgotPasswordTextBtn,
                style: context.textTheme.headlineSmall!
                    .copyWith(color: context.colorScheme.error),
              ),
            ),
          ),
          SizedBox(height: 42.h),
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
          SizedBox(height: 110.h),
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
