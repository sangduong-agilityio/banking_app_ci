import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/auth/widgets/animated_floating_dot.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      backgroundColor: context.colorScheme.primary,
      appBar: BAAppBar(
        title: S.current.signUpTitle,
        alignment: BAAppBarAlignment.left,
        titleColor: context.colorScheme.onPrimary,
        iconColor: context.colorScheme.onPrimary,
        backgroundColor: context.colorScheme.primary,
      ),
      body: Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: context.colorScheme.onPrimary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 52, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.signUpWelcomeTitle,
                  style: context.displaySmall?.copyWith(
                    color: context.colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  S.current.signUpDescription,
                  style: context.labelMedium?.copyWith(
                    color: context.colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 32),
                AnimatedDot(),
                SizedBox(height: 40),
                Text(
                  S.current.signUpTermAndConditions,
                  style: context.bodySmall,
                ),
                SizedBox(height: 40),
                BAElevatedButton(
                  text: S.current.signUpButton,
                  onPressed: () {},
                ),
                SizedBox(height: 14),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: S.current.signUpAlreadyAcccount,
                      style: context.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: context.bodySmall?.copyWith(
                            color: context.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
