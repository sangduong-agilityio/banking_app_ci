import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/utils/validators.dart';
import 'package:tradly_app/widgets/forms/chip_input.dart';
import 'package:tradly_app/widgets/forms/date_picker.dart';
import 'package:tradly_app/widgets/forms/input_suggestions.dart';

class TATextField extends StatefulWidget {
  const TATextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.initialValue,
    this.validator,
    this.validatorStyle,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.scrollPadding = const EdgeInsets.all(20),
    this.onTap,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.onEditingComplete,
    this.maxLines = 1,
    this.maxLength,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.suffixIcon,
    this.prefixIcon,
    this.useMaterialStyle = true,
    this.isChipInput = false,
    this.chips = const [],
    this.onChipsChanged,
    this.isDatePicker = false,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.onDateSubmitted,
    this.suggestions,
    this.isValidOption,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextStyle? validatorStyle;
  final bool isPassword;
  final TextInputType keyboardType;
  final EdgeInsets scrollPadding;
  final VoidCallback? onTap;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;
  final VoidCallback? onEditingComplete;
  final int? maxLines;
  final int? maxLength;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool useMaterialStyle;
  final bool isChipInput;
  final List<String> chips;
  final Function(List<String>)? onChipsChanged;
  final bool isDatePicker;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final ValueChanged<DateTime?>? onDateSubmitted;
  final List<String>? suggestions;
  final bool Function(String)? isValidOption;
  final bool enabled;

  @override
  State<TATextField> createState() => _TATextFieldState();
}

class _TATextFieldState extends State<TATextField> {
  bool _textInvisible = true;

  @override
  Widget build(BuildContext context) {
    if (widget.isChipInput) {
      return InputChipField(
        label: widget.label,
        chips: widget.chips,
        onChipsChanged: widget.onChipsChanged!,
        labelStyle: widget.labelStyle,
      );
    }

    if (widget.isDatePicker) {
      return InputDatePickerField(
        label: widget.label,
        controller: widget.controller!,
        hint: widget.hint,
        initialDate: widget.initialDate,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        onDateSubmitted: widget.onDateSubmitted,
        validator: widget.validator,
        enabled: widget.enabled,
        labelStyle: widget.labelStyle,
      );
    }

    if (widget.suggestions != null && widget.suggestions!.isNotEmpty) {
      return InputSuggestionsField(
        label: widget.label,
        controller: widget.controller!,
        suggestions: widget.suggestions!,
        hint: widget.hint,
        onChanged: widget.onChanged,
        validator: widget.validator,
        enabled: widget.enabled,
        labelStyle: widget.labelStyle,
      );
    }

    return widget.useMaterialStyle
        ? _buildTextField(context)
        : _buildCustomTextField(context);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _textInvisible = !_textInvisible;
    });
  }

  Widget _buildTextField(BuildContext context) {
    final disabledColor = Colors.grey.shade400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: widget.labelStyle ??
              TextStyle(
                color: widget.enabled
                    ? context.colorScheme.onSecondary
                    : disabledColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
        ),
        const SizedBox(height: 8),
        FormBuilderTextField(
          name: widget.label,
          controller: widget.controller,
          focusNode: widget.focusNode,
          initialValue: widget.initialValue,
          cursorColor: context.colorScheme.onSurface,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _textInvisible : false,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          scrollPadding: widget.scrollPadding,
          onChanged: widget.onChanged as ValueChanged<String?>?,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: (value) {
            if (widget.textInputAction == TextInputAction.next) {
              FocusScope.of(context).nextFocus();
            }
            widget.onFieldSubmitted?.call(value ?? '');
          },
          style: widget.textStyle ??
              TextStyle(
                color: widget.enabled
                    ? context.colorScheme.onSurface
                    : disabledColor,
              ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: widget.hint,
            hintStyle: widget.hintStyle ??
                TextStyle(
                  color: widget.enabled
                      ? context.colorScheme.onSurface.withOpacity(0.6)
                      : disabledColor,
                ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: widget.enabled ? Colors.grey : disabledColor,
              ),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: disabledColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.colorScheme.onSecondary),
            ),
            errorStyle: widget.validatorStyle ??
                TextStyle(
                  color: context.colorScheme.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
          ),
          validator: widget.validator ??
              (value) {
                if (widget.isValidOption != null &&
                    value != null &&
                    value.isNotEmpty &&
                    !widget.isValidOption!(value)) {
                  return InputValidationMixin.validateOption(
                      value: value, label: widget.label);
                }
                return InputValidationMixin.validateInput(value, widget.label);
              },
        ),
      ],
    );
  }

  Widget _buildCustomTextField(BuildContext context) {
    final disabledColor = Colors.grey.shade400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormBuilderTextField(
          name: widget.label,
          cursorColor: context.colorScheme.onPrimary,
          cursorErrorColor: context.colorScheme.onPrimary,
          focusNode: widget.focusNode,
          controller: widget.controller,
          onSubmitted: (value) {
            if (widget.textInputAction == TextInputAction.next) {
              FocusScope.of(context).nextFocus();
            }
            widget.onFieldSubmitted?.call(value ?? '');
          },
          onChanged: widget.onChanged as ValueChanged<String?>?,
          onTap: widget.onTap,
          obscuringCharacter: '*',
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: widget.keyboardType,
          scrollPadding: widget.scrollPadding,
          textInputAction: widget.textInputAction,
          initialValue: widget.initialValue,
          style: widget.textStyle ??
              TextStyle(
                color: widget.enabled
                    ? context.colorScheme.onPrimary
                    : disabledColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
          obscureText: widget.isPassword ? _textInvisible : false,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          onEditingComplete: widget.onEditingComplete,
          autofocus: widget.autoFocus,
          enabled: widget.enabled,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            labelStyle: widget.labelStyle ??
                TextStyle(
                  color: widget.enabled
                      ? context.colorScheme.onPrimary
                      : disabledColor,
                ),
            hintStyle: widget.hintStyle ??
                TextStyle(
                  color: widget.enabled
                      ? context.colorScheme.onPrimary.withOpacity(0.6)
                      : disabledColor,
                ),
            isDense: true,
            counterText: '',
            filled: true,
            fillColor: widget.enabled
                ? context.colorScheme.primary
                : context.colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: widget.enabled
                    ? context.colorScheme.onPrimary
                    : disabledColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: context.colorScheme.onPrimary,
                width: 2.0,
              ),
            ),
            errorStyle: widget.validatorStyle ??
                TextStyle(
                  color: context.colorScheme.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    focusNode: FocusNode(skipTraversal: true),
                    icon: Icon(
                      _textInvisible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: widget.enabled
                          ? context.colorScheme.onTertiary
                          : disabledColor,
                      size: 24,
                    ),
                    onPressed: _togglePasswordVisibility,
                  )
                : widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
          ),
          validator: widget.validator ??
              (value) =>
                  InputValidationMixin.validateInput(value, widget.label),
        )
      ],
    );
  }
}
