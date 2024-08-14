import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/constant/constants.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/presentations/widgets/buttons.dart';
import 'package:laza/providers/card_product.dart';
import 'widgets/description_product_detail.dart';
import 'widgets/hearder_product_detail.dart';
import 'widgets/list_view_product_detail.dart';
import 'widgets/list_view_size_product.dart';
import 'widgets/review_product_detail.dart';

class ProductDetailPage extends ConsumerWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  double calculateTotalPriceWithVAT(double price) {
    return price + (price * vatPercentage / 100);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderProductDetail(product: product),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.availableInStock,
                          style: context.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          style: context.textTheme.displayMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          S.current.price,
                          style: context.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${product.price.toString()}',
                          style: context.textTheme.displayMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const ListViewProductDetail(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    S.current.size,
                    style: context.textTheme.headlineLarge,
                  ),
                  const Spacer(),
                  Text(
                    S.current.sizeGuide,
                    style: context.textTheme.headlineMedium!.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListViewSizeProduct(),
            const SizedBox(height: 20),
            DescriptionProductDetail(
              text: product.description,
              maxLines: 6,
              style: context.textTheme.headlineMedium,
              readMoreColor: context.colorScheme.primaryContainer,
              readLessColor: context.colorScheme.primaryContainer,
              expandEnabled: true,
              showTrimmedLines: false,
            ),
            const ReviewProductDetail(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.current.totalPrice,
                        style: context.textTheme.headlineLarge!.copyWith(
                          color: context.colorScheme.primaryContainer,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        S.current.withVatAndSd,
                        style: context.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '\$${calculateTotalPriceWithVAT(product.price.toDouble()).toStringAsFixed(2)}',
                    style: context.textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LSButton(
              text: S.current.addToCart,
              onPressed: () {
                ref.read(cartProvider.notifier).addProduct(product);
              },
            ),
          ],
        ),
      ),
    );
  }
}
