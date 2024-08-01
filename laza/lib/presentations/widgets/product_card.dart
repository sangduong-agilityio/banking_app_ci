import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/presentations/widgets/images.dart';
import 'package:laza/presentations/widgets/tag.dart';

class LSProductCard extends StatelessWidget {
  final String image;
  final String title;
  final int price;
  final void Function()? onTapProduct;

  const LSProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.onTapProduct,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final screenWithTablet = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTapProduct,
      child: Column(
        crossAxisAlignment: screenWithTablet > 600
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          LSImage(
            imageUrl: image,
            height: screenWithTablet > 600 ? 290.h : 203.h,
            width: screenWithTablet > 600 ? 250.w : double.infinity,
          ),
          const SizedBox(height: 5),
          LSTag(
            tagTitle: title,
            tagPrice: price,
          )
        ],
      ),
    );
  }
}
