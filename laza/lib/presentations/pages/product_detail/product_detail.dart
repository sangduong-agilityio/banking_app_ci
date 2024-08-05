import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/presentations/widgets/buttons.dart';
import 'package:laza/providers/product_provider.dart';
import 'widgets/description_product_detail.dart';
import 'widgets/hearder_product_detail.dart';
import 'widgets/list_view_product_detail.dart';
import 'widgets/list_view_size_product.dart';
import 'widgets/review_product_detail.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsNotifierProvider(''));
    return productsAsyncValue.when(
      data: (products) => Scaffold(
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
                        Text(
                          S.current.availableInStock,
                          style: context.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          products.first.name,
                          style: context.textTheme.displayMedium,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.price,
                          style: context.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${products.first.price.toString()}',
                          style: context.textTheme.displayMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const ListViewProductDetail(),
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
                text: products.first.description,
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
                      '\$${products.first.price.toString()}',
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
      ),
      // TODO(SangDuong): Apply shimmer loading and handle error
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
