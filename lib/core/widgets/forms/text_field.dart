import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class BATextField extends StatefulWidget {
  final String name;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool isLast;
  final VoidCallback? onEditingComplete;

  const BATextField({
    super.key,
    required this.name,
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
    this.inputFormatters,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.controller,
    this.onEditingComplete,
    this.isLast = false,
  });

  @override
  State<BATextField> createState() => _BATextFieldState();
}

class _BATextFieldState extends State<BATextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label ?? '', style: context.titleSmall),
          const SizedBox(height: 8),
        ],
        FormBuilderTextField(
          name: widget.name,
          cursorColor: context.colorScheme.primary,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: widget.maxLines,
          focusNode: widget.focusNode,
          controller: widget.controller,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
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
            hintStyle: context.titleSmall?.copyWith(
              color: context.colorScheme.onTertiary,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    focusNode: FocusNode(skipTraversal: true),
                    icon: Icon(
                      widget.suffixIcon,
                      color: widget.enabled
                          ? context.colorScheme.onTertiary
                          : BAAppColors.textDisabled,
                      size: 24,
                    ),
                    onPressed: widget.onSuffixIconTap,
                  )
                : null,
            filled: true,
            fillColor: context.colorScheme.onPrimary,
            errorStyle: TextStyle(
              color: BAAppColors.error,
              fontSize: 12,
              height: 1.2,
            ),
            errorMaxLines: 2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: BAAppColors.textDisabled),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: BAAppColors.textDisabled),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: BAAppColors.borderFocus, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: BAAppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: BAAppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
