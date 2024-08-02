import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/widgets/images.dart';
import 'package:laza/providers/product_provider.dart';

class HeaderProductDetail extends ConsumerWidget {
  const HeaderProductDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsNotifierProvider(''));
    return productsAsyncValue.when(
      data: (product) => Stack(
        clipBehavior: Clip.none,
        children: [
          LSImage(
            imageUrl: product.last.imageUrl,
            width: double.infinity,
            height: 375.h,
            fit: BoxFit.cover,
            borderRadius: 0,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 65,
                right: 20,
                left: 20,
              ),
              child: LSAppBar(
                onTappedBackButton: () => context.pop(),
                icon: LSIcons.icArrowLeft,
                rightButtonIcon: LSIcons.icBag,
                onTappedRightButton: () {},
              ),
            ),
          ),
        ],
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
