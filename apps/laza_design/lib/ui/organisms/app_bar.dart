import 'package:flutter/material.dart';
import 'package:laza_design/core/extenssions/context_extenssions.dart';

class LSAppBar extends StatelessWidget {
  const LSAppBar({
    super.key,
    required this.onTappedBackButton,
    this.onTappedRightButton,
    this.rightButtonIcon,
    required this.icon,
  });
  final VoidCallback? onTappedBackButton;
  final VoidCallback? onTappedRightButton;
  // Icon for the right button
  final Widget? rightButtonIcon;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onTappedBackButton,
          icon: icon ?? const SizedBox.shrink(),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
            backgroundColor: context.colorScheme.outlineVariant,
          ),
        ),
        if (rightButtonIcon != null)
          IconButton(
            onPressed: onTappedRightButton,
            icon: rightButtonIcon ?? const SizedBox.shrink(),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              backgroundColor: context.colorScheme.outlineVariant,
            ),
          ),
      ],
    );
  }
}
