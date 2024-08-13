import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/presentations/widgets/product_card.dart';

class GridViewWishList extends StatelessWidget {
  const GridViewWishList({
    super.key,
    required this.wishListProducts,
  });

  final List<Product> wishListProducts;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: wishListProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: screenWidth > 600 ? 4 / 6 : 7 / 12,
        crossAxisCount: screenWidth > 900
            ? 4
            : screenWidth > 600
                ? 3
                : 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        final product = wishListProducts[index];
        return LSProductCard(
          product: product,
          image: product.imageUrl,
          title: product.name,
          price: product.price,
          onTapProduct: () {
            context.pushNamed(AppRoutesName.productDetailPage.name);
          },
        );
      },
    );
  }
}
