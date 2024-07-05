import 'package:flutter/material.dart';
import 'package:laza/core/widgets/icons.dart';

class LSImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? icon;

  const LSImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: fit,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: icon ?? LSIcons.icHeart,
        ),
      ],
    );
  }
}
