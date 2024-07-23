import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/presentations/widgets/product_card.dart';
import 'package:laza/providers/product_provider.dart';

class GridViewProduct extends ConsumerWidget {
  const GridViewProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider);

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
            price: product.price.toInt(),
            onTapProduct: () {},
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
