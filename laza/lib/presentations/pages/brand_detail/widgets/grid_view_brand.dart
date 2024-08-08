import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/widgets/brand.dart';
import 'package:laza/presentations/widgets/shimmer.dart';
import 'package:laza/providers/brand_provider.dart';

class GridViewBrand extends ConsumerWidget {
  const GridViewBrand({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandAsyncValue = ref.watch(brandProvider);

    return brandAsyncValue.when(
      data: (brand) => GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 15,
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          childAspectRatio: 3 / 1,
        ),
        itemCount: brand.length,
        itemBuilder: (context, index) {
          final brandIndex = brand[index];
          return InkWell(
            onTap: () {
              context.pushNamed(
                AppRoutesName.brandDetailPage.name,
                extra: brandIndex,
              );
            },
            child: LSBrand(
              brandName: brand[index].name,
              brandLogo: brand[index].image,
            ),
          );
        },
      ),
      loading: () => const ShimmerListView(),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
