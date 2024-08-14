import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class LSSize extends StatelessWidget {
  const LSSize({
    super.key,
    required this.size,
  });
  final String size;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.mediaQueryData.size.width;

    return Container(
        width: screenWidth > 600 ? 120.w : 60.w,
        decoration: BoxDecoration(
          color: context.colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            size,
            style: context.textTheme.headlineLarge,
          ),
        ));
  }
}
