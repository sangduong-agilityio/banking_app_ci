import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/widgets/product_card.dart';
import 'package:laza/providers/product_provider.dart';

class GridViewProduct extends ConsumerWidget {
  final String? searchQuery;

  const GridViewProduct({
    super.key,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsNotifierProvider);
    return productsAsyncValue.when(
      data: (products) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 7 / 11,
          mainAxisSpacing: 15,
          crossAxisCount: 2,
          crossAxisSpacing: 15,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return LSProductCard(
            image: product.imageUrl,
            title: product.name,
            price: product.price,
            onTapProduct: () {
              context.pushNamed(AppRoutesName.productDetailPage.name);
            },
          );
        },
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
