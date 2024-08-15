import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/presentations/widgets/empty_widget.dart';
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

    final screenWidth = context.mediaQueryData.size.width;

    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth > 900) {
      crossAxisCount = 4;
      childAspectRatio = 4 / 6;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
      childAspectRatio = 4 / 6;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 7 / 12;
    }

    return productsAsyncValue.when(
      data: (products) {
        if (products.isEmpty) {
          return const EmptyWidget();
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: childAspectRatio,
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.h,
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
      error: (error, stack) => const EmptyWidget(),
    );
  }
}
