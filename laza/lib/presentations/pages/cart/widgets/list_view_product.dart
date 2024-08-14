import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/presentations/pages/cart/widgets/card_product.dart';
import 'package:laza/presentations/widgets/snack_bar.dart';
import 'package:laza/providers/card_product.dart';

class ListCartProduct extends StatelessWidget {
  const ListCartProduct({
    super.key,
    required this.cartProducts,
    required this.cartNotifier,
  });

  final List<Product> cartProducts;
  final CardProductNotifier cartNotifier;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartProducts.length,
      itemBuilder: (context, index) {
        final product = cartProducts[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(product.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              cartNotifier.removeProduct(product);
              LSSnackBar.buildErrorSnackbar(
                  context, '${product.name} ${S.current.removeFormCart}');
            },
            child: LSCardProduct(
              image: product.imageUrl,
              title: product.name,
              price: product.price,
              onTapProduct: () {
                context.pushNamed(AppRoutesName.productDetailPage.name);
              },
            ),
          ),
        );
      },
    );
  }
}
