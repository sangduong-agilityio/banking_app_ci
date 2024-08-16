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
import 'package:laza/presentations/widgets/indicator.dart';
import 'package:laza/presentations/widgets/snack_bar.dart';
import 'package:laza/providers/auth_provider.dart';
import 'widgets/text_input.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});
  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final isFormValidProvider = StateProvider<bool>((ref) => false);
  @override
  Widget build(BuildContext context) {
    final isFormValid = ref.watch(isFormValidProvider);

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

    @override
    void dispose() {
      usernameController.dispose();
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }

    return Scaffold(
      backgroundColor: context.colorScheme.onPrimary,
      body: Column(
        children: [
          SizedBox(height: 45.h),
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
          SizedBox(height: 145.h),
          SignUpForm(
            usernameController: usernameController,
            passwordController: passwordController,
            emailController: emailController,
            onFormValidationChanged: (isValid) {
              ref.read(isFormValidProvider.notifier).state = isValid;
            },
          ),
          const Spacer(),
          LSButton(
            isDisabled: !isFormValid,
            text: S.current.signUpBtn,
            onPressed: () => signUp(),
          )
        ],
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final Function(bool isValid)? onFormValidationChanged;

  const SignUpForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.emailController,
    this.onFormValidationChanged,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          LSForm(
            spaceBetweenRow: 20,
            isValidated: (value) {
              widget.onFormValidationChanged?.call(value);
            },
            textFields: [
              TextInput(
                labelText: S.current.username,
                controller: widget.usernameController,
                validatorText: (value) =>
                    InputValidationMixin.validUserName(value ?? ''),
              ),
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
        ],
      ),
    );
  }
}
