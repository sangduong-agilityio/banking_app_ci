import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/pages/cart/widgets/list_view_product.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/empty_widget.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/providers/card_product.dart';

class CartProductPage extends ConsumerWidget {
  const CartProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProducts = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    const sizeBox20 = SizedBox(height: 20);

    return Scaffold(
      backgroundColor: context.colorScheme.onPrimary,
      body: cartProducts.isEmpty
          ? const EmptyWidget()
          : Column(
              children: [
                SizedBox(height: 45.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LSAppBar(
                    onTappedBackButton: () =>
                        context.go(AppRoutesName.homePage.path),
                    icon: LSIcons.icArrowLeft,
                  ),
                ),
                sizeBox20,
                Center(
                  child: Text(
                    S.current.listCartProduct,
                    style: context.textTheme.displayLarge,
                  ),
                ),
                sizeBox20,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListCartProduct(
                      cartProducts: cartProducts,
                      cartNotifier: cartNotifier,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
