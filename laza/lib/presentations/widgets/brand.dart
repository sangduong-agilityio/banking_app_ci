import 'package:cached_network_image/cached_network_image.dart';
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
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.mediaQueryData.size.width;
    return Container(
      width: screenWidth > 600 ? 160.w : 115.w,
      height: screenWidth > 600 ? 50.h : 50.h,
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
              child: CachedNetworkImage(
                imageUrl: brandLogo,
                height: screenWidth > 600 ? 80.h : 40.h,
                width: screenWidth > 600 ? 80.w : 40.w,
                fit: fit,
                placeholder: (context, url) => Container(
                  color: context.colorScheme.tertiaryContainer,
                ),
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
