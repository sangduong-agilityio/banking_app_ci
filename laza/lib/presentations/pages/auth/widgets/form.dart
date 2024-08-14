import 'package:flutter/material.dart';
import 'text_input.dart';

class LSForm extends StatefulWidget {
  const LSForm({
    super.key,
    required this.textFields,
    required this.isValidated,
    this.spaceBetweenRow = 20,
    this.textInputAction,
  });

  final List<TextInput> textFields;

  final double spaceBetweenRow;

  final Function(bool value) isValidated;

  final TextInputAction? textInputAction;

  @override
  State<LSForm> createState() => _OLFormState();
}

class _OLFormState extends State<LSForm> {
  final formStateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formStateKey,
      onChanged: () {
        (widget.textFields.every((element) =>
                (element.controller!.text.isNotEmpty ||
                    element.controller == null)))
            ? widget.isValidated(formStateKey.currentState!.validate())
            : widget.isValidated(false);
      },
      child: Column(
        children: [
          for (final (index, input) in widget.textFields.indexed) ...[
            if (index != widget.textFields.length - 1) ...[
              input.copyWith(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => input.focusNode?.nextFocus(),
              ),
              SizedBox(
                height: widget.spaceBetweenRow,
              ),
            ] else
              input.copyWith(
                textInputAction: widget.textInputAction ?? TextInputAction.done,
                onEditingComplete: () {
                  if (formStateKey.currentState!.validate()) {
                    widget.isValidated(true);
                  }
                },
              ),
          ],
        ],
      ),
    );
  }
}
