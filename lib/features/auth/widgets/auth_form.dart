import 'package:banking_app/core/utils/validators.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class BAForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final Widget child;
  final VoidCallback? onSubmit;

  const BAForm({
    super.key,
    required this.formKey,
    required this.child,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [child, const SizedBox(height: 16)],
      ),
    );
  }
}

class UsernameInput extends StatelessWidget {
  final String? name;
  final String? label;
  final String? hint;
  final String? initialValue;
  final List<String? Function(String?)>? validators;

  const UsernameInput({
    super.key,
    this.name,
    this.label,
    this.hint,
    this.initialValue,
    this.validators,
  });

  @override
  Widget build(BuildContext context) {
    return BATextField(
      name: name ?? '',
      label: label,
      hint: hint ?? 'Enter name',
      keyboardType: TextInputType.phone,
      initialValue: initialValue,

      validators:
          validators ??
          [
            (value) => InputValidationMixin.validUserName(value ?? '') != null
                ? null
                : 'Username must be at least 3 characters long',
          ],
    );
  }
}

class EmailInput extends StatelessWidget {
  final String? name;
  final String? label;
  final String? hint;
  final String? initialValue;
  final List<String? Function(String?)>? validators;

  const EmailInput({
    super.key,
    this.name,
    this.label,
    this.hint,
    this.initialValue,
    this.validators,
  });

  @override
  Widget build(BuildContext context) {
    return BATextField(
      name: name ?? '',
      label: label,
      hint: hint ?? 'Enter email address',
      keyboardType: TextInputType.emailAddress,
      initialValue: initialValue,
      validators:
          validators ??
          [
            (value) => value != null
                ? InputValidationMixin.validEmail(value)
                : 'Email is required',
          ],
    );
  }
}

class PasswordInput extends StatefulWidget {
  final String? name;
  final String? label;
  final String? hint;
  final String? initialValue;
  final List<String? Function(String?)>? validators;

  const PasswordInput({
    super.key,
    this.name,
    this.label,
    this.hint,
    this.initialValue,
    this.validators,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BATextField(
      name: widget.name ?? '',
      label: widget.label,
      hint: widget.hint ?? 'Enter password',
      suffixIcon: _obscureText ? Icons.visibility_off : Icons.visibility,
      onSuffixIconTap: () => setState(() => _obscureText = !_obscureText),
      obscureText: _obscureText,
      initialValue: widget.initialValue,
      validators:
          widget.validators ??
          [
            (value) => value != null
                ? InputValidationMixin.validPassword(value)
                : 'Password is required',
          ],
    );
  }
}
