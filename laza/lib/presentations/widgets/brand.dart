import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class LSBrand extends StatelessWidget {
  final String brandName;
  final String brandLogo;
  final BoxFit fit;

  const LSBrand({
    super.key,
    required this.brandName,
    required this.brandLogo,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: context.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                brandLogo,
                width: 40.w,
                height: 40.h,
                fit: fit,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            brandName,
            style: context.textTheme.headlineMedium!.copyWith(
              color: context.colorScheme.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
