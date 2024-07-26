import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/presentations/widgets/brand.dart';
import 'package:laza/providers/brand_provider.dart';

class ListViewBrand extends ConsumerWidget {
  const ListViewBrand({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandAsyncValue = ref.watch(brandProvider);

    return brandAsyncValue.when(
      data: (brand) => InkWell(
        onTap: () {
          context.pushNamed(
            AppRoutesName.brandViewAll.name,
          );
        },
        child: SizedBox(
          height: 50.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: brand.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final brands = brand[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: LSBrand(
                  brandName: brands.name,
                  brandLogo: brands.image,
                ),
              );
            },
          ),
        ),
      ),

      // TODO(SangDuong): Apply shimmer loading and handle error
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
