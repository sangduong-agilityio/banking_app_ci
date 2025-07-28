import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/utils/date_time.dart';
import 'package:tradly_app/utils/validators.dart';

class InputDatePickerField extends StatefulWidget {
  const InputDatePickerField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSubmitted,
    this.validator,
    this.enabled = true,
    this.labelStyle,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onDateSubmitted;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextStyle? labelStyle;

  @override
  State<InputDatePickerField> createState() => _InputDatePickerFieldState();
}

class _InputDatePickerFieldState extends State<InputDatePickerField>
    with InputValidationMixin {
  Future<void> _handleDatePickerTap(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final pickedDate = await showDatePickerDialog(
      context: context,
      minDate: widget.firstDate ?? DateTime(1900),
      maxDate: widget.lastDate ?? DateTime(2100),
      initialDate: widget.initialDate ?? DateTime.now(),
      selectedDate: widget.initialDate,
    );

    if (pickedDate != null) {
      widget.controller.text = DateTimeUtil.formatPickerValue(pickedDate);
      widget.onDateSubmitted?.call(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        FormBuilderTextField(
          name: widget.label,
          controller: widget.controller,
          enabled: widget.enabled,
          onTap: () => _handleDatePickerTap(context),
          readOnly: false,
          textInputAction: TextInputAction.next,
          style: TextStyle(color: context.colorScheme.onSurface),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: widget.hint,
            suffixIcon:
                Icon(Icons.calendar_today, color: context.colorScheme.primary),
            border: const UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: widget.enabled
                      ? Colors.grey
                      : context.colorScheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.colorScheme.onSecondary),
            ),
            errorStyle: TextStyle(
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
    );
  }
}
