import 'package:flutter/material.dart';
import 'package:laza/core/widgets/brand.dart';

class LSListViewBrand extends StatelessWidget {
  const LSListViewBrand({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(right: 10),
            child: LSBrand(
              brandName: 'Nike',
              brandLogo: 'https://picsum.photos/id/237/200/300',
            ),
          );
        },
      ),
    );
  }
}
