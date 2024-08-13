import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/providers/product_list_provider.dart';

class LSAppBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final totalProductsInCart = ref.watch(cartProvider).length;

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
            if (totalProductsInCart > 0)
              Positioned(
                child: Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: context.colorScheme.error,
                  ),
                  child: Text(
                    '$totalProductsInCart',
                    style: TextStyle(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
          ]),
      ],
    );
  }
}
