import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// A card widget for displaying a beneficiary.
class BeneficiaryCard extends StatelessWidget {
  const BeneficiaryCard({
    super.key,
    this.width = 100,
    this.height = 120,
    this.isSelected = false,
    this.isEnabled = true,
    this.disabledReason,
    required this.onTap,
    required this.child,
  });

  final double width;
  final double height;
  final bool isSelected;
  final bool isEnabled;
  final String? disabledReason;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.secondary
            : (isEnabled
                  ? colorScheme.onPrimary
                  : colorScheme.outlineVariant.withAlpha(50)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? colorScheme.secondary
              : colorScheme.outlineVariant,
        ),
      ),
      child: child,
    );

    if (isEnabled) {
      return GestureDetector(onTap: onTap, child: card);
    }

    return Tooltip(message: disabledReason ?? '', child: card);
  }
}
