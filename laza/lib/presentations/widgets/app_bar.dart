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
          width: 68.w,
          height: 45.h,
          decoration: ShapeDecoration(
            image: DecorationImage(
              image: Image.network(
                centerImage ?? '',
              ).image,
              fit: fit,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        if (rightButtonIcon != null)
          Stack(children: [
            IconButton(
              onPressed: onTappedRightButton,
              icon: rightButtonIcon ?? const SizedBox.shrink(),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                backgroundColor: context.colorScheme.outlineVariant,
              ),
            ),
            Positioned(
              child: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: context.colorScheme.error,
                ),
                child: const Text(
                  '',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
      ],
    );
  }
}
