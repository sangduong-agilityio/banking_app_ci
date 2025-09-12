import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class BeneficiaryCard extends StatelessWidget {
  final double width;
  final double height;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  const BeneficiaryCard({
    super.key,
    this.width = 100,
    this.height = 120,
    this.isSelected = false,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.secondary : colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colorScheme.secondary
                : colorScheme.outlineVariant,
          ),
        ),
        child: child,
      ),
    );
  }
}
