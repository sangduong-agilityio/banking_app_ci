import 'package:flutter/material.dart';
import 'package:laza/core/widgets/images.dart';
import 'package:laza/core/widgets/tag.dart';

class LSProductCard extends StatelessWidget {
  final String image;
  final String title;
  final int price;
  final void Function()? onTapProduct;

  const LSProductCard(
      {super.key,
      required this.image,
      required this.title,
      required this.onTapProduct,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapProduct,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LSImage(
            imageUrl: image,
            height: 203,
            width: double.infinity,
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
