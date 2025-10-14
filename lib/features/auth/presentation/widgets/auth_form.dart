import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/features/auth/presentation/widgets/animated_floating_dot.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

/// A generic form widget for authentication (sign-in and sign-up).
///
/// This widget provides a flexible and reusable form structure with a title,
/// description, text fields, a submit button, and an optional footer.
/// It uses [FormBuilder] to manage the form state and validation.
class AuthForm extends StatefulWidget {
  /// Creates an [AuthForm] object.
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

  /// The title of the form.
  final String? title;

  /// A short description or subtitle for the form.
  final String? description;

  /// A list of text field widgets to display in the form.
  final List<Widget>? textFields;

  /// A callback function that is called when the form is submitted.
  final VoidCallback? onSubmit;

  /// The text to display on the submit button.
  final String? submitText;

  /// A callback function that is called when the form's validation state changes.
  final void Function(bool isValid)? onValidate;

  /// A widget to display at the bottom of the form.
  final Widget? footer;

  /// Whether to show the terms and conditions checkbox.
  final bool showTerms;

  /// Whether the terms and conditions are accepted.
  final bool isTermsAccepted;

  /// A callback function that is called when the terms and conditions checkbox is changed.
  final ValueChanged<bool?>? onTermsChanged;

  /// An optional height for the form.
  final SizedBox? height;

  /// An extra widget to display between the form fields and the terms and conditions.
  final Widget? extra;

  /// Whether the submit button is enabled.
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          const AnimatedDot(),
          _buildFormFields(),
          if (widget.extra != null) ...[
            const SizedBox(height: 12),
            widget.extra ?? const SizedBox(),
          ],
          if (widget.showTerms) _buildTermsAndConditions(context),
          const SizedBox(height: 20),
          _buildSubmitButton(),
          if (widget.footer != null) ...[
            const SizedBox(height: 14),
            Center(child: widget.footer ?? const SizedBox()),
          ],
          SizedBox(height: widget.height?.height ?? 20),
        ],
      ),
    );
  }

  /// Builds the header of the form, including the title and description.
  Widget _buildHeader(BuildContext context) {
    return Column(
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
      ],
    );
  }

  /// Builds the form fields using [FormBuilder].
  Widget _buildFormFields() {
    return FormBuilder(
      key: formKey,
      onChanged: _onFormChanged,
      child: Column(
        children: [
          for (int i = 0; i < (widget.textFields ?? []).length; i++) ...[
            (widget.textFields ?? [])[i],
            if (i != (widget.textFields ?? []).length - 1)
              const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  /// Builds the terms and conditions section.
  Widget _buildTermsAndConditions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => widget.onTermsChanged?.call(!widget.isTermsAccepted),
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
    );
  }

  /// Builds the submit button.
  Widget _buildSubmitButton() {
    return BAElevatedButton(
      padding: EdgeInsets.zero,
      isDisabled: !_allFieldsValid || !widget.isSubmitEnabled,
      text: widget.submitText ?? '',
      onPressed: widget.onSubmit,
    );
  }
}
