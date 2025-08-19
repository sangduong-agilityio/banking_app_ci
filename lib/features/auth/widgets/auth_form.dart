import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class BAForm extends StatefulWidget {
  const BAForm({
    super.key,
    required this.textFields,
    this.spaceBetweenRow = 20,
    required this.isValidated,
    this.textInputAction,
  });

  final List<Widget> textFields;
  final double spaceBetweenRow;
  final Function(bool value) isValidated;

  final TextInputAction? textInputAction;

  @override
  State<BAForm> createState() => _BAFormState();
}

class _BAFormState extends State<BAForm> {
  final formStateKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formStateKey,
      onChanged: () {
        // Save and validate the form state
        formStateKey.currentState?.save();
        final isValid = formStateKey.currentState?.validate() ?? false;
        widget.isValidated(isValid);
      },
      child: Column(
        children: [
          for (int index = 0; index < widget.textFields.length; index++) ...[
            widget.textFields[index],
            if (index != widget.textFields.length - 1)
              SizedBox(height: widget.spaceBetweenRow),
          ],
        ],
      ),
    );
  }
}

class UsernameInput extends StatelessWidget {
  final String? name;
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const UsernameInput({
    super.key,
    this.name,
    this.label,
    this.hint,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return BATextField(
      name: name ?? '',
      label: label,
      hint: hint ?? 'Enter name',
      keyboardType: TextInputType.name,
      controller: controller,
      validator: validator,
    );
  }
}

class EmailInput extends StatelessWidget {
  final String? name;
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const EmailInput({
    super.key,
    this.name,
    this.label,
    this.hint,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return BATextField(
      name: name ?? '',
      label: label,
      controller: controller,
      hint: hint ?? 'Enter email address',
      keyboardType: TextInputType.emailAddress,
      validator: validator,
    );
  }
}

class PasswordInput extends StatefulWidget {
  final String? name;
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PasswordInput({
    super.key,
    this.name,
    this.label,
    this.hint,
    this.controller,
    this.validator,
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
      controller: widget.controller,
      validator: widget.validator,
    );
  }
}
