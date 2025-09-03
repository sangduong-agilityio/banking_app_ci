import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/features/auth/widgets/animated_floating_dot.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    this.title,
    this.description,
    this.textFields,
    this.onSubmit,
    this.submitText,
    this.onValidate,
    this.footer,
    this.showTerms = false,
    this.isTermsAccepted = false,
    this.onTermsChanged,
    this.isSubmitEnabled = true,
    this.height,
    this.extra,
  });

  final String? title;
  final String? description;
  final List<Widget>? textFields;
  final VoidCallback? onSubmit;
  final String? submitText;
  final void Function(bool isValid)? onValidate;
  final Widget? footer;
  final bool showTerms;
  final bool isTermsAccepted;
  final ValueChanged<bool?>? onTermsChanged;
  final SizedBox? height;
  final Widget? extra;
  final bool isSubmitEnabled;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final formKey = GlobalKey<FormBuilderState>();
  bool _allFieldsValid = false;

  void _onFormChanged() {
    final isValid =
        formKey.currentState?.fields.values.every((field) {
          return field.isValid &&
              (field.value?.toString().trim().isNotEmpty ?? false);
        }) ??
        false;

    if (_allFieldsValid != isValid) {
      setState(() => _allFieldsValid = isValid);
      widget.onValidate?.call(isValid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: context.colorScheme.onPrimary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title ?? '',
                  style: context.displaySmall?.copyWith(
                    color: context.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.description ?? '',
                  style: context.labelMedium?.copyWith(
                    color: context.colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                const AnimatedDot(),
                FormBuilder(
                  key: formKey,
                  onChanged: _onFormChanged,
                  child: Column(
                    children: [
                      for (
                        int i = 0;
                        i < (widget.textFields ?? []).length;
                        i++
                      ) ...[
                        (widget.textFields ?? [])[i],
                        if (i != (widget.textFields ?? []).length - 1)
                          const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),

                if (widget.extra != null) ...[
                  const SizedBox(height: 12),
                  widget.extra ?? const SizedBox(),
                ],

                if (widget.showTerms) ...[
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => widget.onTermsChanged?.call(
                          !widget.isTermsAccepted,
                        ),
                        child: Icon(
                          widget.isTermsAccepted
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: widget.isTermsAccepted
                              ? context.colorScheme.secondary
                              : context.colorScheme.onTertiary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: S.current.signUpTermAndConditions,
                            style: context.bodySmall?.copyWith(
                              color: context.colorScheme.scrim,
                            ),
                            children: [
                              TextSpan(
                                text: S.current.signUpTermAndConditionButton,
                                style: context.bodySmall?.copyWith(
                                  color: context.colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.pop(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                BAElevatedButton(
                  padding: EdgeInsets.zero,
                  isDisabled: !_allFieldsValid || !widget.isSubmitEnabled,
                  text: widget.submitText ?? '',
                  onPressed: widget.onSubmit,
                ),

                if (widget.footer != null) ...[
                  const SizedBox(height: 14),
                  Center(child: widget.footer ?? const SizedBox()),
                ],

                SizedBox(height: widget.height?.height ?? 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
