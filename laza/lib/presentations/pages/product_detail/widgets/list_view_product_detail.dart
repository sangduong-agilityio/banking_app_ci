import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/presentations/widgets/images.dart';
import 'package:laza/providers/product_notifier.dart';

class ListViewProductDetail extends ConsumerWidget {
  const ListViewProductDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider);
    return productsAsyncValue.when(
      data: (products) => Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 77.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: LSImage(
                    width: 77.w,
                    height: 77.h,
                    borderRadius: 10,
                    imageUrl: product.imageUrl),
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
