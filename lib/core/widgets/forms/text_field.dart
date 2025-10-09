import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// A custom text field widget with various configurations and validation support.
///
/// This widget can be used for regular text input, passwords, and can be customized with icons, labels, and hints.
class BATextField extends StatefulWidget {
  /// Creates a [BATextField] widget.
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

  /// The name of the field.
  final String? name;

  /// The label to display above the field.
  final String? label;

  /// The hint text to display inside the field.
  final String? hint;

  /// The icon to display before the text.
  final Widget? prefixIcon;

  /// The icon to display after the text.
  final Widget? suffixIcon;

  /// The callback that is called when the suffix icon is tapped.
  final VoidCallback? onSuffixIconTap;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// Whether to obscure the text being edited.
  final bool obscureText;

  /// The validator function to use for validating the input.
  final String? Function(String?)? validator;

  /// The maximum number of lines to show in the field.
  final int? maxLines;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// The list of input formatters to use for the field.
  final List<TextInputFormatter>? inputFormatters;

  /// The text input action to use for the field.
  final TextInputAction? textInputAction;

  /// The focus node to use for the field.
  final FocusNode? focusNode;

  /// The controller to use for the field.
  final TextEditingController? controller;

  /// The callback that is called when the editing is complete.
  final VoidCallback? onEditingComplete;

  /// The fill color to use for the field.
  final Color? fillColor;

  /// Whether the field is a password field.
  final bool isPassword;

  /// The callback that is called when the value of the field changes.
  final ValueChanged<String?>? onChanged;

  /// The text style to use for the hint text.
  final TextStyle? hintTextStyle;

  /// The autovalidate mode to use for the field.
  final AutovalidateMode autovalidateMode;

  @override
  State<BATextField> createState() => _BATextFieldState();
}

/// The state for a [BATextField] widget.
class _BATextFieldState extends State<BATextField> {
  bool _textInvisible = true;
  final _iconFocusNode = FocusNode(skipTraversal: true);
  final _formFieldKey = GlobalKey<FormFieldState>();
  String? _errorText;

  @override
  void dispose() {
    _iconFocusNode.dispose();
    super.dispose();
  }

  /// Toggles the visibility of the password.
  void _togglePasswordVisibility() {
    setState(() => _textInvisible = !_textInvisible);
  }

  /// Validates the field and updates the error text.
  void _validateField() {
    if (widget.validator != null) {
      final error = widget.validator!(_formFieldKey.currentState?.value);
      if (_errorText != error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _errorText = error);
          }
        });
      }
    }
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
          key: _formFieldKey,
          name: widget.name ?? '',
          cursorColor: context.colorScheme.primary,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _textInvisible : widget.obscureText,
          autovalidateMode: widget.autovalidateMode,
          focusNode: widget.focusNode,
          controller: widget.controller,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          onChanged: (value) {
            widget.onChanged?.call(value);
            _validateField();
          },
          onEditingComplete:
              widget.onEditingComplete ??
              () {
                if (widget.textInputAction == TextInputAction.next) {
                  FocusScope.of(context).nextFocus();
                } else if (widget.textInputAction == TextInputAction.done) {
                  FocusScope.of(context).unfocus();
                }
              },
          validator: (value) {
            final error = widget.validator?.call(value);
            if (_errorText != error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() => _errorText = error);
                }
              });
            }
            return error;
          },
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
