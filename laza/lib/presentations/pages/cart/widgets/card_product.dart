import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/presentations/widgets/images.dart';
import 'package:laza/presentations/widgets/tag.dart';

class LSCardProduct extends StatelessWidget {
  final String image;
  final String title;
  final int price;
  final void Function()? onTapProduct;

  const LSCardProduct({
    super.key,
    required this.image,
    required this.title,
    required this.onTapProduct,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapProduct,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LSImage(
            imageUrl: image,
            icon: LSIcons.icHeartBreak,
            height: 170.h,
            width: 140.w,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: LSTag(
              tagTitle: title,
              tagPrice: price,
            ),
          ),
        ],
      ),
    );
  }
}
