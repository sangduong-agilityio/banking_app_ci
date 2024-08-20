import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    required this.title,
    required this.isActivateViewAll,
    required this.color,
    super.key,
    this.onTap,
  });
  final String title;
  final VoidCallback? onTap;
  final bool isActivateViewAll;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Row(
          children: [
            Text(
              title,
              style: context.textTheme.headlineLarge,
            ),
          ],
        ),
        if (isActivateViewAll)
          GestureDetector(
            onTap: onTap,
            child: Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Text(
                S.current.viewAll,
                style: context.textTheme.bodyLarge?.copyWith(color: color),
              ),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
