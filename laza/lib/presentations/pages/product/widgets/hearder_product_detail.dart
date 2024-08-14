import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/widgets/images.dart';
import 'package:laza/providers/product_provider.dart';

class HeaderProductDetail extends ConsumerWidget {
  final Product product;

  const HeaderProductDetail({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = context.mediaQueryData.size.width;
    final selectedImageUrl = ref.watch(productsNotifierProvider('')).maybeWhen(
          data: (products) {
            final notifier = ref.read(productsNotifierProvider('').notifier);
            return notifier.selectedImageUrl;
          },
          orElse: () => '',
        );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        LSImage(
          imageUrl:
              selectedImageUrl.isNotEmpty ? selectedImageUrl : product.imageUrl,
          width: double.infinity,
          height: screenWidth > 600 ? 750.h : 375.h,
          fit: BoxFit.cover,
          borderRadius: 0,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              top: 45.h,
              right: 20.w,
              left: 20.w,
            ),
            child: LSAppBar(
              onTappedBackButton: () => context.pop(),
              icon: LSIcons.icArrowLeft,
              rightButtonIcon: LSIcons.icBag,
              onTappedRightButton: () {},
            ),
          ),
        ),
      ],
    );
  }
}
