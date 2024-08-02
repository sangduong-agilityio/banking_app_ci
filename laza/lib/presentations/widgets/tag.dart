import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class LSTag extends StatelessWidget {
  const LSTag({
    super.key,
    required this.tagTitle,
    required this.tagPrice,
  });

  final String tagTitle;
  final int tagPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tagTitle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.titleMedium!
              .copyWith(color: context.colorScheme.primaryContainer),
        ),
        const SizedBox(height: 5),
        Text(
          '\$${tagPrice.toString()}',
          style: context.textTheme.bodyMedium!
              .copyWith(color: context.colorScheme.primaryContainer),
        ),
      ],
    );
  }
}
