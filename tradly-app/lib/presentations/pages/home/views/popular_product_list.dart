import 'package:flutter/widgets.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/presentations/widgets/card.dart';

class PopularProductList extends StatelessWidget {
  const PopularProductList({
    super.key,
    this.products,
  });

  final List<ProductModel>? products;

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
              id: products?[index].id ?? 0,
              title: products?[index].title ?? '',
              imageUrl: products?[index].imageUrl ?? '',
              price: products?[index].price ?? '',
              brand: products?[index].brand ?? '',
            ),
            onTapProduct: () {},
          );
        },
      ),
    );
  }
}
