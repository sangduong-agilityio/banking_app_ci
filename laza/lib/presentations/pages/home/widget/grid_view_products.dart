import 'package:flutter/material.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/presentations/widgets/product_card.dart';

class GridViewProduct extends StatelessWidget {
  const GridViewProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 7 / 10,
          mainAxisSpacing: 15,
          crossAxisCount: 2,
          crossAxisSpacing: 15,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return LSProductCard(
            image: Assets.images.dataImage.path,
            title: 'Nike Sportswear Club Fleece',
            price: 123,
            onTapProduct: () {},
          );
        },
      ),
    );
  }
}
