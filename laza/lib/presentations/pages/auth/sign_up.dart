import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/buttons.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/layout/scaffold.dart';
import 'widgets/text_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    const sizeBox20 = SizedBox(height: 20);
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
          const SizedBox(height: 145),
          const SignUpForm(sizeBox20: sizeBox20),
          const SizedBox(height: 280),
          LSButton(text: S.current.signUpBtn, onPressed: () {})
        ],
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.sizeBox20,
  });

  final SizedBox sizeBox20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextInput(
            labelText: S.current.username,
          ),
          sizeBox20,
          TextInput(
            labelText: S.current.email,
          ),
          sizeBox20,
          TextInput(
            labelText: S.current.password,
            hasObscureText: true,
          ),
        ],
      ),
    );
  }
}
