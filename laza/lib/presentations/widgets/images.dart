import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class LSImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? icon;
  final BoxShape? shape;
  final double borderRadius;

  const LSImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.icon,
    this.shape,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: CachedNetworkImage(
            width: width,
            height: height,
            imageUrl: imageUrl,
            fit: fit,
            placeholder: (context, url) => Container(
              color: context.colorScheme.surface,
            ),
          ),
        ),
        if (icon != null)
          Positioned(
            top: 10,
            right: 10,
            child: icon ?? const SizedBox.shrink(),
          ),
      ],
    );
  }
}
