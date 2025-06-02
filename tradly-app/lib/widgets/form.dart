import 'package:flutter/material.dart';
import 'package:tradly_app/widgets/text_field.dart';

class TAForm extends StatefulWidget {
  const TAForm({
    super.key,
    required this.textFields,
    required this.isValidated,
    this.spaceBetweenRow = 15,
    this.textInputAction,
  });

  final List<dynamic> textFields;
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
            return (element.children.every((child) =>
                child is TATextField &&
                (child.controller?.text.isNotEmpty ?? true)));
          }
          return element.controller?.text.isNotEmpty ?? true;
        });

        widget.isValidated(
            allFieldsValid && formStateKey.currentState!.validate());
      },
      child: Column(
        children: [
          for (final (index, input) in widget.textFields.indexed) ...[
            if (index != widget.textFields.length - 1) ...[
              if (input is Row)
                input
              else
                input.copyWith(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => input.focusNode?.nextFocus(),
                ),
              SizedBox(
                height: widget.spaceBetweenRow,
              ),
            ] else if (input is Row)
              input
            else
              input.copyWith(
                textInputAction: widget.textInputAction ?? TextInputAction.done,
                onEditingComplete: () {
                  final isValid =
                      formStateKey.currentState?.validate() ?? false;
                  widget.isValidated(isValid);
                },
              ),
          ],
        ],
      ),
    );
  }
}
