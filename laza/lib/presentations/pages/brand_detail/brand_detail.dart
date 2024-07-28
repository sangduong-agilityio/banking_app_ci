import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/layout/scaffold.dart';
import 'package:laza/providers/brand_provider.dart';
import 'widgets/sort_detail.dart';
import '../home/widget/grid_view_products.dart';

class BrandDetailPage extends ConsumerWidget {
  const BrandDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandAsyncValue = ref.watch(brandProvider);
    return brandAsyncValue.when(
      data: (brand) => LazaShopScaffold(
        paddingScaffold: 20,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 45.h),
              LSAppBar(
                onTappedBackButton: () => context.pop(),
                icon: LSIcons.icArrowLeft,
                rightButtonIcon: LSIcons.icBag,
                onTappedRightButton: () {},
                centerImage: brand.last.image,
              ),
              SizedBox(height: 49.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.current.totalItems(256),
                        style: context.textTheme.headlineLarge,
                      ),
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
              const GridViewProduct()
            ],
          ),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
