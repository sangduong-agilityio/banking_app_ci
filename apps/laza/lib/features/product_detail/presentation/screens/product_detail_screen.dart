import 'package:flutter/material.dart';
import 'package:laza/core/extenssions/context_extenssions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/widgets/buttons.dart';
import 'package:laza/features/product_detail/presentation/widgets/description_product_detail.dart';
import 'package:laza/features/product_detail/presentation/widgets/hearder_product_detail.dart';
import 'package:laza/features/product_detail/presentation/widgets/list_view_product_detail.dart';
import 'package:laza/features/product_detail/presentation/widgets/list_view_size_product.dart';
import 'package:laza/features/product_detail/presentation/widgets/review_product_detail.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderProductDetail(),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.current.availableInStock,
                          style: context.textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      Text(S.current.availableInStock,
                          style: context.textTheme.displayMedium),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.current.price, style: context.textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      Text(
                        S.current.price,
                        style: context.textTheme.displayMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const LSListViewProductDetail(),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
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
              text:
                  'The Nike Throwback Pullover Hoodie is made from premium French terry fabric that blends a performance feel with a relaxed fit. It features a classic kangaroo pocket and a drawstring hood for added comfort. The Nike logo is embroidered on the chest for a classic look.',
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
                      Text(S.current.withVatAndSd,
                          style: context.textTheme.titleMedium),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '125',
                    style: context.textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LSButton(
              text: S.current.addToCart,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
