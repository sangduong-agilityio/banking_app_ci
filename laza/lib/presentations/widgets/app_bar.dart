import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class LSAppBar extends StatelessWidget {
  const LSAppBar({
    super.key,
    required this.onTappedBackButton,
    this.onTappedRightButton,
    this.rightButtonIcon,
    required this.icon,
    this.centerImage,
    this.fit = BoxFit.cover,
  });
  final VoidCallback onTappedBackButton;
  final VoidCallback? onTappedRightButton;
  // Icon for the right button
  final Widget? rightButtonIcon;
  final Widget? icon;
  final String? centerImage;

  final BoxFit fit;

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
        Container(
          width: 68,
          height: 45,
          decoration: ShapeDecoration(
            image: DecorationImage(
              image: NetworkImage(centerImage ?? ''),
              fit: fit,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
