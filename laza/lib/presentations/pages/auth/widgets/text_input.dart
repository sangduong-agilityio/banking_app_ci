import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    super.key,
    required this.labelText,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.validatorText,
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
  });

  final String labelText;

  final TextStyle? labelStyle;

  final String? initialValue;

  final ValueChanged<String>? onChanged;

  final String? Function(String?)? validatorText;

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
    return TextFormField(
      contextMenuBuilder: widget.validatorText != null
          ? (context, editableTextState) {
              final List<ContextMenuButtonItem> buttonItems =
                  editableTextState.contextMenuButtonItems;
              buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
                return buttonItem.type == ContextMenuButtonType.cut ||
                    buttonItem.type == ContextMenuButtonType.copy;
              });
              return AdaptiveTextSelectionToolbar.buttonItems(
                anchors: editableTextState.contextMenuAnchors,
                buttonItems: buttonItems,
              );
            }
          : null,
      cursorColor: context.colorScheme.primaryContainer,
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
      style: widget.textStyle ?? context.inputTheme.hintStyle,
      obscureText: widget.hasObscureText ? _textInvisible : false,
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.maxLength ?? 50,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        hintStyle: widget.hintStyle,
        isDense: true,
        counterText: '',
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
    );
  }
}
