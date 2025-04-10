import 'package:flutter/widgets.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/presentations/widgets/card.dart';

class NewProductList extends StatelessWidget {
  const NewProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return TACardProduct(
            product: ProductModel(
              id: '1',
              title: 'Vegetable',
              imageUrl: 'assets/images/vegetable.png',
              price: '10',
              brand: 'Tradly',
            ),
            onTapProduct: () {},
          );
        },
      ),
    );
  }
}
