import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/utils/validators.dart';

class InputSuggestionsField extends StatelessWidget {
  const InputSuggestionsField({
    super.key,
    required this.label,
    required this.controller,
    required this.suggestions,
    this.hint,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.labelStyle,
  });

  final String label;
  final TextEditingController controller;
  final List<String> suggestions;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final disabledColor = Colors.grey.shade400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ??
              TextStyle(
                color:
                    enabled ? context.colorScheme.onSecondary : disabledColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
        ),
        const SizedBox(height: 8),
        Autocomplete<String>(
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                color: context.colorScheme.surface,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(option),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return suggestions.where((suggestion) => suggestion
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (String selection) {
            controller.text = selection;
            onChanged?.call(selection);
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return FormBuilderTextField(
              name: label,
              controller: textEditingController,
              focusNode: focusNode,
              enabled: enabled,
              cursorColor: context.colorScheme.onSurface,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextStyle(
                color: enabled ? context.colorScheme.onSurface : disabledColor,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: hint,
                hintStyle: TextStyle(
                  color: enabled
                      ? context.colorScheme.onSurface.withOpacity(0.6)
                      : disabledColor,
                ),
                border: const UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: enabled ? Colors.grey : disabledColor,
                  ),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: disabledColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: context.colorScheme.onSecondary),
                ),
                errorStyle: TextStyle(
                  color: context.colorScheme.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onChanged: onChanged as ValueChanged<String?>?,
              validator: validator ??
                  (value) => InputValidationMixin.validateInput(value, label),
            );
          },
        ),
      ],
    );
  }
}
