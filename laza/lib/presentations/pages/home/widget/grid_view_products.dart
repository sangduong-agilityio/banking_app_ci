import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/presentations/widgets/product_card.dart';
import 'package:laza/presentations/widgets/shimmer.dart';
import 'package:laza/providers/product_provider.dart';

class GridViewProduct extends ConsumerWidget {
  final String? searchQuery;
  final List<Product>? products;
  final int? brandId;

  const GridViewProduct({
    super.key,
    this.searchQuery,
    this.brandId,
    this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(
      productsNotifierProvider(
        searchQuery ?? '',
        brandId: brandId,
      ),
    );
    final screenWithTablet = MediaQuery.of(context).size.width;

    return productsAsyncValue.when(
      data: (products) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: screenWithTablet > 600 ? 4 / 6 : 7 / 12,
            crossAxisCount: screenWithTablet > 900
                ? 4
                : screenWithTablet > 600
                    ? 3
                    : 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return LSProductCard(
              product: product,
              image: product.imageUrl,
              title: product.name,
              price: product.price,
              onTapProduct: () {
                context.pushNamed(
                  AppRoutesName.productDetailPage.name,
                  extra: product,
                );
              },
            );
          },
        );
      },
      loading: () => const ShimmerGridView(),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
