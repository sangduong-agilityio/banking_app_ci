import 'package:flutter/material.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';

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
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.onTap,
    this.textInputAction,
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
    this.dropdownItems,
    this.onDropdownChanged,
    this.useMaterialStyle = true,
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
  final Function(String)? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;
  final VoidCallback? onEditingComplete;
  final int? maxLines;
  final int? maxLength;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final IconData? suffixIcon;
  final List<DropdownMenuItem<String>>? dropdownItems;
  final ValueChanged<String?>? onDropdownChanged;
  final bool useMaterialStyle;

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
    Function(String)? onFieldSubmitted,
    ValueChanged<String>? onChanged,
    bool? autoFocus,
    VoidCallback? onEditingComplete,
    int? maxLines,
    int? maxLength,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    IconData? suffixIcon,
    List<DropdownMenuItem<String>>? dropdownItems,
    ValueChanged<String?>? onDropdownChanged,
    bool? useMaterialStyle,
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
      dropdownItems: dropdownItems ?? this.dropdownItems,
      onDropdownChanged: onDropdownChanged ?? this.onDropdownChanged,
      useMaterialStyle: useMaterialStyle ?? this.useMaterialStyle,
    );
  }
}

class _TATextFieldState extends State<TATextField> {
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
    return widget.useMaterialStyle
        ? _buildMaterialTextField(context)
        : _buildCustomTextField(context);
  }

  Widget _buildMaterialTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: widget.labelStyle ??
                TextStyle(
                  color: context.colorScheme.outline,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
          ),
          TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _textInvisible : false,
            obscuringCharacter: '*',
            textInputAction: widget.textInputAction,
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onFieldSubmitted,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            onEditingComplete: widget.onEditingComplete,
            autofocus: widget.autoFocus,
            scrollPadding: widget.scrollPadding,
            style: widget.textStyle ??
                TextStyle(color: context.colorScheme.onSurface),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: context.colorScheme.primary),
              ),
              hintText: widget.hint,
              hintStyle: widget.hintStyle ?? TextStyle(color: Colors.grey[400]),
              counterText: '',
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _textInvisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: togglePasswordVisibility,
                    )
                  : widget.suffixIcon != null
                      ? Icon(widget.suffixIcon, color: Colors.grey)
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          cursorColor: context.colorScheme.onPrimary,
          cursorErrorColor: context.colorScheme.onPrimary,
          focusNode: widget.focusNode,
          controller: widget.controller,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: widget.onChanged,
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
          enableSuggestions: false,
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
            prefixIcon: widget.dropdownItems != null
                ? DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: widget.dropdownItems
                          ?.map((item) => DropdownMenuItem<String>(
                                value: item.value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: item.child,
                                ),
                              ))
                          .toList(),
                      onChanged: widget.onDropdownChanged,
                      menuWidth: 100,
                      value: widget.dropdownItems?.first.value,
                      dropdownColor: Colors.transparent.withOpacity(0),
                      iconSize: 30,
                      alignment: AlignmentDirectional.centerEnd,
                      style: TextStyle(
                        color: context.colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      iconEnabledColor: context.colorScheme.onPrimary,
                      iconDisabledColor: context.colorScheme.onSurface,
                      selectedItemBuilder: (BuildContext context) {
                        return widget.dropdownItems
                                ?.map((item) => Center(
                                      child: Text(
                                        item.value ?? '',
                                        style: TextStyle(
                                          color: context.colorScheme.onPrimary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ))
                                .toList() ??
                            [];
                      },
                    ),
                  )
                : null,
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
                : widget.suffixIcon != null
                    ? Icon(widget.suffixIcon,
                        color: context.colorScheme.onTertiary)
                    : null,
          ),
          validator: widget.validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ${widget.label}';
                }
                return null;
              },
        )
      ],
    );
  }
}
