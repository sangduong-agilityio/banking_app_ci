import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/utils/validators.dart';
import 'package:tradly_app/widgets/text.dart';

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
  final TextInputAction? textInputAction;
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

  @override
  State<TATextField> createState() => _TATextFieldState();

  TATextField copyWith({
    String? label,
    TextEditingController? controller,
    String? hint,
    String? initialValue,
    String? Function(String?)? validator,
    TextStyle? validatorStyle,
    bool? isPassword,
    TextInputType? keyboardType,
    EdgeInsets? scrollPadding,
    VoidCallback? onTap,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    ValueChanged<String?>? onFieldSubmitted,
    ValueChanged<String>? onChanged,
    bool? autoFocus,
    VoidCallback? onEditingComplete,
    int? maxLines,
    int? maxLength,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool? useMaterialStyle,
    bool? isChipInput,
    List<String>? chips,
    Function(List<String>)? onChipsChanged,
  }) {
    return TATextField(
      label: label ?? this.label,
      controller: controller ?? this.controller,
      hint: hint ?? this.hint,
      initialValue: initialValue ?? this.initialValue,
      validator: validator ?? this.validator,
      validatorStyle: validatorStyle ?? this.validatorStyle,
      isPassword: isPassword ?? this.isPassword,
      keyboardType: keyboardType ?? this.keyboardType,
      scrollPadding: scrollPadding ?? this.scrollPadding,
      onTap: onTap ?? this.onTap,
      textInputAction: textInputAction ?? this.textInputAction,
      focusNode: focusNode ?? this.focusNode,
      onFieldSubmitted: onFieldSubmitted ?? this.onFieldSubmitted,
      onChanged: onChanged ?? this.onChanged,
      autoFocus: autoFocus ?? this.autoFocus,
      onEditingComplete: onEditingComplete ?? this.onEditingComplete,
      maxLines: maxLines ?? this.maxLines,
      maxLength: maxLength ?? this.maxLength,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      useMaterialStyle: useMaterialStyle ?? this.useMaterialStyle,
      isChipInput: isChipInput ?? this.isChipInput,
      chips: chips ?? this.chips,
      onChipsChanged: onChipsChanged ?? this.onChipsChanged,
    );
  }
}

class _TATextFieldState extends State<TATextField> with InputValidationMixin {
  late bool _textInvisible;

  @override
  void initState() {
    super.initState();
    _textInvisible = true;
  }

  void togglePasswordVisibility() {
    setState(() {
      _textInvisible = !_textInvisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isChipInput) {
      return _buildDynamicChip(context);
    } else {
      return widget.useMaterialStyle
          ? _buildTextField(context)
          : _buildCustomTextField(context);
    }
  }

  Widget _buildTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: widget.labelStyle ??
                TextStyle(
                  color: context.colorScheme.onSecondary,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
          ),
          FormBuilderTextField(
            name: widget.label,
            cursorColor: context.colorScheme.onSurface,
            controller: widget.controller,
            initialValue: widget.initialValue,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _textInvisible : false,
            obscuringCharacter: '*',
            textInputAction: widget.textInputAction,
            focusNode: widget.focusNode,
            onSubmitted: (value) {
              if (widget.textInputAction == TextInputAction.next) {
                FocusScope.of(context).nextFocus();
              }
              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted!(value ?? '');
              }
            },
            onChanged: widget.onChanged as ValueChanged<String?>?,
            onTap: widget.onTap,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onEditingComplete: widget.onEditingComplete,
            autofocus: widget.autoFocus,
            style: widget.textStyle ??
                TextStyle(color: context.colorScheme.onSurface),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 10),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffdbdbde),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: context.colorScheme.onSurface),
              ),
              errorStyle: widget.validatorStyle ??
                  TextStyle(
                    color: context.colorScheme.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            validator: widget.validator ??
                (value) =>
                    InputValidationMixin.validateInput(value, widget.label),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField(BuildContext context) {
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
            if (widget.onFieldSubmitted != null) {
              widget.onFieldSubmitted!(value ?? '');
            }
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
                color: context.colorScheme.onPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
          obscureText: widget.isPassword ? _textInvisible : false,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          onEditingComplete: widget.onEditingComplete,
          autofocus: widget.autoFocus,
          decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              labelStyle: widget.labelStyle ??
                  TextStyle(
                    color: context.colorScheme.onPrimary,
                  ),
              hintStyle: widget.hintStyle,
              isDense: true,
              counterText: '',
              filled: true,
              fillColor: context.colorScheme.primary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: context.colorScheme.onPrimary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: context.colorScheme.onPrimary,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: context.colorScheme.onPrimary,
                  width: 2.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: context.colorScheme.onPrimary,
                  width: 2.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
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
                        color: context.colorScheme.onTertiary,
                        size: 24,
                      ),
                      onPressed: togglePasswordVisibility,
                    )
                  : widget.suffixIcon),
          validator: widget.validator ??
              (value) =>
                  InputValidationMixin.validateInput(value, widget.label),
        )
      ],
    );
  }

  Widget _buildDynamicChip(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: widget.labelStyle ??
              TextStyle(
                color: context.colorScheme.onSecondary,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xffdbdbde),
                width: 1.0,
              ),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...widget.chips.map((chip) => _buildChip(context, chip)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    return Chip(
      label: TATitleLargeText(
        text: label,
        color: context.colorScheme.onSurface,
      ),
      backgroundColor: Colors.grey[300],
      deleteIcon: widget.onChipsChanged != null
          ? const Icon(Icons.close, size: 18)
          : null,
      onDeleted:
          widget.onChipsChanged != null ? () => _removeChip(label) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          style: BorderStyle.none,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  void _removeChip(String chip) {
    if (widget.onChipsChanged != null) {
      widget.onChipsChanged!(widget.chips.where((c) => c != chip).toList());
    }
  }
}
