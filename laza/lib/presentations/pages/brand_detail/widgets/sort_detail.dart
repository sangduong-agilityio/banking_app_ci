import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/presentations/widgets/icons.dart';

class LSSort extends StatefulWidget {
  const LSSort({
    super.key,
  });

  @override
  State<LSSort> createState() => _LSSortState();
}

class _LSSortState extends State<LSSort> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 71.w,
      height: 37.h,
      decoration: BoxDecoration(
        color: context.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () {
          _showSortDialog(context);
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

  void _showSortDialog(BuildContext context) {
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
                    S.current.price,
                  ),
                  onTap: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text(
                    S.current.brands,
                  ),
                  onTap: () {
                    setState(() {});
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
