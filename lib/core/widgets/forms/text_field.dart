import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class BATextField extends StatefulWidget {
  const BATextField({
    super.key,
    this.name,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.inputFormatters,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.controller,
    this.onEditingComplete,
    this.fillColor,
    this.isPassword = false,
    this.onChanged,
    this.hintTextStyle,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String? name;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool enabled;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final VoidCallback? onEditingComplete;
  final Color? fillColor;
  final bool isPassword;
  final ValueChanged<String?>? onChanged;
  final TextStyle? hintTextStyle;
  final AutovalidateMode autovalidateMode;

  @override
  State<BATextField> createState() => _BATextFieldState();
}

class _BATextFieldState extends State<BATextField> {
  bool _textInvisible = true;
  final _iconFocusNode = FocusNode(skipTraversal: true);

  @override
  void dispose() {
    _iconFocusNode.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _textInvisible = !_textInvisible);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: context.titleSmall),
          const SizedBox(height: 8),
        ],
        FormBuilderTextField(
          name: widget.name ?? '',
          cursorColor: context.colorScheme.primary,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _textInvisible : widget.obscureText,
          autovalidateMode: widget.autovalidateMode,
          maxLines: widget.maxLines,
          focusNode: widget.focusNode,
          controller: widget.controller,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onEditingComplete:
              widget.onEditingComplete ??
              () {
                if (widget.textInputAction == TextInputAction.next) {
                  FocusScope.of(context).nextFocus();
                } else if (widget.textInputAction == TextInputAction.done) {
                  FocusScope.of(context).unfocus();
                }
              },
          validator: widget.validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            hintText: widget.hint,
            hintStyle:
                widget.hintTextStyle ??
                context.titleSmall?.copyWith(
                  color: context.colorScheme.onTertiary,
                ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    focusNode: _iconFocusNode,
                    icon: Icon(
                      _textInvisible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: widget.enabled
                          ? context.colorScheme.onTertiary
                          : BAAppColors.textDisabled,
                      size: 24,
                    ),
                    onPressed: _togglePasswordVisibility,
                  )
                : (widget.suffixIcon != null
                      ? GestureDetector(
                          onTap: widget.onSuffixIconTap,
                          child: widget.suffixIcon,
                        )
                      : null),
            filled: true,
            fillColor:
                widget.fillColor ??
                (widget.enabled
                    ? context.colorScheme.onPrimary
                    : BAAppColors.textDisabled),
            errorStyle: const TextStyle(
              color: BAAppColors.error,
              fontSize: 12,
              height: 1.2,
            ),
            errorMaxLines: 2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: BAAppColors.textDisabled),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: BAAppColors.textDisabled),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: BAAppColors.borderFocus,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: BAAppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: BAAppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
