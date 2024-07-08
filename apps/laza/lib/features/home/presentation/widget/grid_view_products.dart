import 'package:flutter/material.dart';
import 'package:laza/core/widgets/product_card.dart';

class LSGridViewProduct extends StatelessWidget {
  const LSGridViewProduct({
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
            image: 'https://picsum.photos/seed/picsum/200/300',
            title: 'Nike Sportswear Club Fleece',
            price: 123,
            onTapProduct: () {},
          );
        },
      ),
    );
  }
}
