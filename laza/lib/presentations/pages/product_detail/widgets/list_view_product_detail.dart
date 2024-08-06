import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/themes/colors.dart';
import 'package:laza/presentations/widgets/images.dart';
import 'package:laza/presentations/widgets/shimmer.dart';
import 'package:laza/providers/product_provider.dart';

class ListViewProductDetail extends ConsumerWidget {
  const ListViewProductDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsNotifierProvider(''));

    return productsAsyncValue.when(
      data: (products) {
        final productsNotifier =
            ref.read(productsNotifierProvider('').notifier);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 77.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    productsNotifier.selectImage(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: productsNotifier.selectedImageIndex == index
                              ? LSColors.grey300
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: LSImage(
                        width: 77.w,
                        height: 77.h,
                        borderRadius: 10,
                        imageUrl: product.imageUrl,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () => const ShimmerListView(),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
