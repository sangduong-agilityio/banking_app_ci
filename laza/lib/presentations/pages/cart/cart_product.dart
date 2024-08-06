import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/widgets/product_card.dart';
import 'package:laza/presentations/widgets/snack_bar.dart';
import 'package:laza/providers/cart_provider.dart';

class CartProductPage extends ConsumerWidget {
  const CartProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProducts = ref.watch(cartNotifierProvider);
    final cartNotifier = ref.read(cartNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: context.colorScheme.onPrimary,
      body: cartProducts.isEmpty
          ? Center(child: Text(S.current.noProductInCart))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 45.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LSAppBar(
                      onTappedBackButton: () => context.pop(),
                      icon: LSIcons.icArrowLeft,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      S.current.letGetStarted,
                      style: context.textTheme.displayLarge,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProducts.length,
                      itemBuilder: (context, index) {
                        final product = cartProducts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Dismissible(
                            key: Key(product.id.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              cartNotifier.removeProduct(product);
                              LSSnackBar.buildErrorSnackbar(
                                  context,
                                  '${product.name}'
                                  '${S.current.removeFormCart}');
                            },
                            child: LSProductCard(
                              image: product.imageUrl,
                              title: product.name,
                              price: product.price,
                              onTapProduct: () {
                                context.pushNamed(
                                    AppRoutesName.productDetailPage.name);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
