import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/presentations/widgets/icons.dart';

class LSSort extends StatelessWidget {
  const LSSort({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 71,
      height: 37,
      decoration: BoxDecoration(
        color: context.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () {},
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
}
