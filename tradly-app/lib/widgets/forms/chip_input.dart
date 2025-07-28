import 'package:flutter/material.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/widgets/text.dart';

class InputChipField extends StatelessWidget {
  const InputChipField({
    super.key,
    required this.label,
    required this.chips,
    required this.onChipsChanged,
    this.labelStyle,
  });

  final String label;
  final List<String> chips;
  final Function(List<String>) onChipsChanged;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ??
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
                color: const Color(0xffdbdbde),
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
              children: chips.map((chip) => _buildChip(context, chip)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String chipLabel) {
    return Chip(
      label: TATitleLargeText(
        text: chipLabel,
        color: context.colorScheme.onSurface,
      ),
      backgroundColor: Colors.grey[300],
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: () => _removeChip(chipLabel),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(style: BorderStyle.none),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  void _removeChip(String chip) {
    final updatedChips = chips.where((c) => c != chip).toList();
    onChipsChanged(updatedChips);
  }
}
