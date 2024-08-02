import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/widgets/brand.dart';
import 'package:laza/presentations/widgets/shimmer.dart';
import 'package:laza/providers/brand_provider.dart';

class ListViewBrand extends ConsumerWidget {
  const ListViewBrand({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandAsyncValue = ref.watch(brandProvider);
    final screenWithTablet = MediaQuery.of(context).size.width;

    return brandAsyncValue.when(
      data: (brand) => InkWell(
        onTap: () {
          context.pushNamed(
            AppRoutesName.brandViewAll.name,
          );
        },
        child: SizedBox(
          height: screenWithTablet > 600 ? 80.h : 50.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: brand.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final brands = brand[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: screenWithTablet > 600 ? 15 : 10,
                ),
                child: LSBrand(
                  brandName: brands.name,
                  brandLogo: brands.image,
                ),
              );
            },
          ),
        ),
      ),

      // TODO(SangDuong): Handle error
      loading: () => const ShimmerListView(),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
