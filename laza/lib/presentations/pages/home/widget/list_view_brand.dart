import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/widgets/brand.dart';
import 'package:laza/presentations/widgets/empty_widget.dart';
import 'package:laza/presentations/widgets/shimmer.dart';
import 'package:laza/providers/brand_provider.dart';

class ListViewBrand extends ConsumerWidget {
  const ListViewBrand({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandAsyncValue = ref.watch(brandProvider);
    final screenWidth = context.mediaQueryData.size.width;

    return brandAsyncValue.when(
        data: (brands) => InkWell(
              child: SizedBox(
                height: screenWidth > 600 ? 80.h : 50.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: brands.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: screenWidth > 600 ? 15.w : 10.w,
                      ),
                      child: InkWell(
                        onTap: () {
                          context.pushNamed(
                            AppRoutesName.brandDetailPage.name,
                            extra: brand,
                          );
                        },
                        child: LSBrand(
                          brandName: brand.name,
                          brandLogo: brand.image,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        loading: () => const ShimmerListView(),
        error: (error, stack) => const EmptyWidget());
  }
}
