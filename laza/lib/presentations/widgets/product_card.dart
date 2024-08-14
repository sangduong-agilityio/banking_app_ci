import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/widgets/images.dart';
import 'package:laza/presentations/widgets/tag.dart';
import 'package:laza/providers/card_product.dart';

class LSProductCard extends ConsumerWidget {
  final String image;
  final String title;
  final int price;
  final Product product;
  final void Function()? onTapProduct;

  const LSProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.onTapProduct,
    required this.price,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishList = ref.watch(wishListProvider);
    final isFavorite = wishList.contains(product);
    final screenWithTablet = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTapProduct,
      child: Column(
        crossAxisAlignment: screenWithTablet > 600
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          LSImage(
            isFavorite: isFavorite,
            imageUrl: image,
            icon: LSIcons.icHeartBreak,
            height: screenWithTablet > 600 ? 290.h : 203.h,
            width: screenWithTablet > 600 ? 250.w : double.infinity,
            onTapIcon: () {
              final wishListNotifier = ref.read(wishListProvider.notifier);
              if (isFavorite) {
                wishListNotifier.removeProduct(product);
              } else {
                wishListNotifier.addProduct(product);
              }
            },
          ),
          const SizedBox(height: 5),
          LSTag(
            tagTitle: title,
            tagPrice: price,
          )
        ],
      ),
    );
  }
}
