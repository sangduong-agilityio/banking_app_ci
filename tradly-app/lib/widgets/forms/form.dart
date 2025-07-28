import 'package:flutter/material.dart';
import 'package:tradly_app/widgets/forms/text_field.dart';

class TAForm extends StatefulWidget {
  const TAForm({
    super.key,
    required this.textFields,
    required this.isValidated,
    this.spaceBetweenRow = 15,
    this.textInputAction,
  });

  final List<Widget> textFields;
  final double spaceBetweenRow;
  final Function(bool value) isValidated;
  final TextInputAction? textInputAction;

  @override
  State<TAForm> createState() => _TAFormState();
}

class _TAFormState extends State<TAForm> {
  final formStateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formStateKey,
      onChanged: () {
        final allFieldsValid = widget.textFields.every((element) {
          if (element is Row) {
            return element.children.every((child) =>
                child is TATextField &&
                (child.controller?.text.isNotEmpty ?? true));
          }
          return element is TATextField &&
              (element.controller?.text.isNotEmpty ?? true);
        });

        widget.isValidated(
            allFieldsValid && formStateKey.currentState!.validate());
      },
      child: Column(
        children: [
          for (int index = 0; index < widget.textFields.length; index++) ...[
            _updateWidget(index, widget.textFields[index]),
            if (index != widget.textFields.length - 1)
              SizedBox(height: widget.spaceBetweenRow),
          ]
        ],
      ),
    );
  }

  Widget _updateWidget(int index, Widget input) {
    final isLast = index == widget.textFields.length - 1;

    if (input is Row) return input;

    if (input is TATextField) {
      return TATextField(
        key: input.key,
        label: input.label,
        controller: input.controller,
        hint: input.hint,
        initialValue: input.initialValue,
        validator: input.validator,
        isPassword: input.isPassword,
        keyboardType: input.keyboardType,
        focusNode: input.focusNode,
        onChanged: input.onChanged,
        autoFocus: input.autoFocus,
        maxLines: input.maxLines,
        maxLength: input.maxLength,
        textStyle: input.textStyle,
        hintStyle: input.hintStyle,
        labelStyle: input.labelStyle,
        suffixIcon: input.suffixIcon,
        prefixIcon: input.prefixIcon,
        isChipInput: input.isChipInput,
        chips: input.chips,
        onChipsChanged: input.onChipsChanged,
        isDatePicker: input.isDatePicker,
        firstDate: input.firstDate,
        lastDate: input.lastDate,
        initialDate: input.initialDate,
        onDateSubmitted: input.onDateSubmitted,
        suggestions: input.suggestions,
        useMaterialStyle: input.useMaterialStyle,
        isValidOption: input.isValidOption,
        enabled: input.enabled,
        scrollPadding: input.scrollPadding,
        textInputAction: isLast
            ? widget.textInputAction ?? TextInputAction.done
            : TextInputAction.next,
        onEditingComplete: isLast
            ? () {
                final isValid = formStateKey.currentState?.validate() ?? false;
                widget.isValidated(isValid);
              }
            : () => input.focusNode?.nextFocus(),
        onFieldSubmitted: input.onFieldSubmitted,
      );
    }

    return input;
  }
}
