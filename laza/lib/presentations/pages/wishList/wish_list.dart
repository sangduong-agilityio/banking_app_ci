import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/presentations/pages/wishList/widgets/grid_view_wish_list.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/providers/wish_list_provider.dart';

class WishListPage extends ConsumerWidget {
  const WishListPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishListProducts = ref.watch(wishListNotifierProvider);
    final wishListNotifier = ref.watch(wishListNotifierProvider.notifier);
    return Scaffold(
      backgroundColor: context.colorScheme.onPrimary,
      body: wishListProducts.isEmpty
          ? const Center(child: Text('No products in wishlist'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 25.h),
                    LSAppBar(
                      onTappedBackButton: () => context.pop(),
                      icon: LSIcons.icArrowLeft,
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Text(
                        S.current.listCartProduct,
                        style: context.textTheme.displayLarge,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    GridViewWishList(
                      wishListNotifier: wishListNotifier,
                      wishListProducts: wishListProducts,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
