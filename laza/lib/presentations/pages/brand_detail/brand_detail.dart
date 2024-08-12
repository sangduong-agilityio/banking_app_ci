import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/data/models/brand_model.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/empty_widget.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/layout/scaffold.dart';
import 'package:laza/providers/product_provider.dart';
import 'widgets/sort_detail.dart';
import '../home/widget/grid_view_products.dart';

class BrandDetailPage extends ConsumerWidget {
  const BrandDetailPage({
    required this.brand,
    super.key,
  });

  final Brand brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LazaShopScaffold(
      paddingScaffold: 20,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25.h),
            LSAppBar(
              onTappedBackButton: () => context.pop(),
              icon: LSIcons.icArrowLeft,
              rightButtonIcon: LSIcons.icBag,
              onTappedRightButton: () {
                context.pushNamed(
                  AppRoutesName.cartProductPage.name,
                );
              },
              centerImage: brand.image,
            ),
            SizedBox(height: 49.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer(builder: (context, ref, _) {
                      final productsAsyncValue =
                          ref.watch(productsNotifierProvider(
                        '',
                        brandId: brand.id,
                      ));
                      return productsAsyncValue.when(
                          data: (products) => Text(
                                S.current.totalItems(products.length),
                                style: context.textTheme.headlineLarge,
                              ),
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => const EmptyWidget());
                    }),
                    const SizedBox(height: 5),
                    Text(
                      S.current.availableInStock,
                      style: context.textTheme.headlineSmall!.copyWith(
                          color: context.colorScheme.tertiaryContainer),
                    ),
                  ],
                ),
                const LSSort()
              ],
            ),
            SizedBox(height: 20.h),
            GridViewProduct(
              searchQuery: '',
              brandId: brand.id,
            )
          ],
        ),
      ),
    );
  }
}
