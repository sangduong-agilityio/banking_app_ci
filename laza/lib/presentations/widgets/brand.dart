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
      width: 110,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(brandLogo),
                  fit: fit,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(brandName,
              style: context.textTheme.headlineMedium!
                  .copyWith(color: context.colorScheme.primaryContainer)),
        ],
      ),
    );
  }
}
