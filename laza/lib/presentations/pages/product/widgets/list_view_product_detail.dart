import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/presentations/widgets/empty_widget.dart';
import 'package:laza/presentations/widgets/images.dart';
import 'package:laza/presentations/widgets/shimmer.dart';
import 'package:laza/providers/product_provider.dart';

class ListViewProductDetail extends ConsumerWidget {
  final int productId;
  const ListViewProductDetail({
    required this.productId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsNotifier = ref.read(productsNotifierProvider('').notifier);
    productsNotifier.resetSelectedImage();

    final productsAsyncValue = ref.watch(productsNotifierProvider(''));
    final tabletScreen = context.mediaQueryData.size.width;

    return productsAsyncValue.when(
        data: (products) {
          if (productsNotifier.productImages.isEmpty) {
            return const EmptyWidget();
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: tabletScreen > 600 ? 140.h : 77.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productsNotifier.productImages.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final productImage = productsNotifier.productImages[index];

                  return GestureDetector(
                    onTap: () {
                      productsNotifier.selectImage(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: LSImage(
                        width: tabletScreen > 600 ? 140.w : 77.w,
                        borderRadius: 10,
                        imageUrl: productImage.imageUrl,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
        loading: () => const ShimmerListView(),
        error: (error, stack) => const EmptyWidget());
  }
}
