import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/providers/product_provider.dart';

final sortProvider = StateProvider<SortType>((ref) => SortType.priceLowToHigh);

enum SortType {
  priceLowToHigh,
  priceHighToLow,
}

class LSSort extends ConsumerWidget {
  const LSSort({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(sortProvider);

    return Container(
      width: 71.w,
      height: 37.h,
      decoration: BoxDecoration(
        color: context.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () {
          _showSortDialog(context, ref);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LSIcons.icSort,
            const SizedBox(width: 5),
            Text(
              S.current.sort,
              style: context.textTheme.headlineMedium!.copyWith(
                color: context.colorScheme.primaryContainer,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showSortDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: context.colorScheme.outlineVariant,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.current.sort,
                  style: context.textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    S.current.priceLowToHigh,
                  ),
                  onTap: () {
                    ref
                        .read(sortProvider.notifier)
                        .update((state) => SortType.priceLowToHigh);
                    ref
                        .read(productsNotifierProvider('').notifier)
                        .sortProducts(SortType.priceLowToHigh);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text(
                    S.current.priceHighToLow,
                  ),
                  onTap: () {
                    ref.read(sortProvider.notifier).state =
                        SortType.priceHighToLow;
                    ref
                        .read(productsNotifierProvider('').notifier)
                        .sortProducts(SortType.priceHighToLow);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
