import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/core/utils/validators.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/buttons.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/layout/scaffold.dart';
import 'package:laza/presentations/widgets/indicator.dart';
import 'package:laza/presentations/widgets/snack_bar.dart';
import 'package:laza/providers/auth_provider.dart';
import 'widgets/text_input.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final emailController = TextEditingController();

    void signUp() {
      LSLoadingIndicator.show(context);
      ref
          .read(authRepositoryProvider)
          .signUp(
              email: emailController.text,
              password: passwordController.text,
              username: usernameController.text)
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
          const SizedBox(height: 145),
          SignUpForm(
            sizeBox20: const SizedBox(height: 20),
            usernameController: usernameController,
            passwordController: passwordController,
            emailController: emailController,
          ),
          const SizedBox(height: 280),
          LSButton(
            text: S.current.signUpBtn,
            onPressed: () => signUp(),
          )
        ],
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final SizedBox sizeBox20;

  const SignUpForm({
    super.key,
    required this.sizeBox20,
    required this.usernameController,
    required this.passwordController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextInput(
            labelText: S.current.username,
            controller: usernameController,
            validatorText: (value) =>
                InputValidationMixin.validUserName(value ?? ''),
          ),
          sizeBox20,
          TextInput(
            labelText: S.current.email,
            controller: emailController,
            validatorText: (value) =>
                InputValidationMixin.validEmail(value ?? ''),
          ),
          sizeBox20,
          TextInput(
            labelText: S.current.password,
            controller: passwordController,
            validatorText: (value) =>
                InputValidationMixin.validPassword(value ?? ''),
            hasObscureText: true,
          ),
        ],
      ),
    );
  }
}
