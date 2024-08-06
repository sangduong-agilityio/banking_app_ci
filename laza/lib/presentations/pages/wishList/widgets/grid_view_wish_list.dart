import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/presentations/widgets/product_card.dart';
import 'package:laza/presentations/widgets/snack_bar.dart';
import 'package:laza/providers/wish_list_provider.dart';

class GridViewWishList extends StatelessWidget {
  const GridViewWishList({
    super.key,
    required this.wishListNotifier,
    required this.wishListProducts,
  });
  final List<Product> wishListProducts;
  final WishListNotifier wishListNotifier;
  @override
  Widget build(BuildContext context) {
    final screenWithTablet = MediaQuery.of(context).size.width;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: wishListProducts.length,
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
      itemBuilder: (context, index) {
        final product = wishListProducts[index];
        return Dismissible(
            key: Key(product.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              wishListNotifier.removeProduct(product);
              LSSnackBar.buildErrorSnackbar(
                  context,
                  '${product.name}'
                  '${S.current.removeFormCart}');
            },
            child: LSProductCard(
              product: product,
              image: product.imageUrl,
              title: product.name,
              price: product.price,
              onTapProduct: () {
                context.pushNamed(AppRoutesName.productDetailPage.name);
              },
            ));
      },
    );
  }
}
