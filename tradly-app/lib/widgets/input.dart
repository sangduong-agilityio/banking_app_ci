import 'package:flutter/material.dart';
import 'package:tradly_app/extensions/context_extensions.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    super.key,
    required this.labelText,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.validatorText,
    this.validatorStyle, // New property for validator text style
    this.hasObscureText = false,
    this.keyboardType = TextInputType.text,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.onTap,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
    this.autoFocus = false,
    this.onEditingComplete,
    this.maxLines,
    this.maxLength,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.dropdownItems,
    this.onDropdownChanged,
  });

  final String labelText;

  final TextStyle? labelStyle;

  final String? initialValue;

  final ValueChanged<String>? onChanged;

  final String? Function(String?)? validatorText;

  final TextStyle? validatorStyle; // New property

  final bool hasObscureText;

  final TextInputType keyboardType;

  final EdgeInsets scrollPadding;

  final VoidCallback? onTap;

  final FocusNode? focusNode;

  final TextInputAction? textInputAction;

  final Function(String)? onFieldSubmitted;

  final TextEditingController? controller;

  final VoidCallback? onEditingComplete;

  final bool autoFocus;

  final int? maxLines;

  final int? maxLength;

  final TextStyle? hintStyle;

  final TextStyle? textStyle;

  final List<DropdownMenuItem<String>>? dropdownItems;

  final ValueChanged<String?>? onDropdownChanged;

  @override
  State<TextInput> createState() => _TextInputState();

  TextInput copyWith({
    String? hintText,
    String? labelText,
    Function(String? string)? onChanged,
    VoidCallback? onEditingComplete,
    bool? autoFocus,
    TextInputAction? textInputAction,
    String? Function(String?)? validatorText,
    String? initialValue,
    bool? hasObscureText,
    TextInputType? keyboardType,
    EdgeInsets? scrollPadding,
    VoidCallback? onTap,
    FocusNode? focusNode,
    Function(String)? onFieldSubmitted,
    TextEditingController? controller,
    int? maxLines,
    int? maxLength,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextStyle? textStyle,
    List<DropdownMenuItem<String>>? dropdownItems,
    ValueChanged<String?>? onDropdownChanged,
  }) {
    return TextInput(
      labelText: labelText ?? this.labelText,
      onChanged: onChanged ?? this.onChanged,
      onEditingComplete: onEditingComplete ?? this.onEditingComplete,
      autoFocus: autoFocus ?? this.autoFocus,
      textInputAction: textInputAction ?? this.textInputAction,
      validatorText: validatorText ?? this.validatorText,
      initialValue: initialValue ?? this.initialValue,
      hasObscureText: hasObscureText ?? this.hasObscureText,
      keyboardType: keyboardType ?? this.keyboardType,
      scrollPadding: scrollPadding ?? this.scrollPadding,
      onTap: onTap ?? this.onTap,
      focusNode: focusNode ?? this.focusNode,
      onFieldSubmitted: onFieldSubmitted ?? this.onFieldSubmitted,
      controller: controller ?? this.controller,
      maxLines: maxLines ?? this.maxLines,
      maxLength: maxLength ?? this.maxLength,
      hintStyle: hintStyle ?? this.hintStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      textStyle: textStyle ?? this.textStyle,
      dropdownItems: dropdownItems ?? this.dropdownItems,
      onDropdownChanged: onDropdownChanged ?? this.onDropdownChanged,
    );
  }
}

class _TextInputState extends State<TextInput> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          cursorColor: context.colorScheme.onPrimary,
          cursorErrorColor: context.colorScheme.onPrimary,
          focusNode: widget.focusNode,
          controller: widget.controller,
          onFieldSubmitted: widget.onFieldSubmitted,
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
          obscureText: widget.hasObscureText ? _textInvisible : false,
          maxLines: widget.maxLines ?? 1,
          maxLength: widget.maxLength ?? 50,
          enableSuggestions: false,
          decoration: InputDecoration(
            labelText: widget.labelText,
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
            prefixIcon: widget.dropdownItems != null
                ? DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      // isDense: true,
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
            suffixIcon: widget.hasObscureText
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
                : null,
          ),
          validator: widget.validatorText,
        )
      ],
    );
  }
}
