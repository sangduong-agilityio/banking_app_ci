import 'package:flutter/material.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/widgets/card.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class BeveragesList extends StatelessWidget {
  const BeveragesList({
    super.key,
    this.products,
  });
  final List<ProductModel>? products;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaAppBar(
        toolbarHeight: TaAppBarSize.medium,
        alignmentTitle: TaTitleAlignment.center,
        bottomType: TaAppBarBottomType.option,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: TaDisplaySmallText(
            text: 'Beverages',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
          ),
          itemCount: products?.length ?? 8,
          itemBuilder: (context, index) {
            return TACardProduct(
              onTapProduct: () {},
              product: ProductModel(
                id: products?[index].id,
                title: products?[index].title ?? '',
                imageUrl: products?[index].imageUrl ?? '',
                price: products?[index].price.toString() ?? '0',
                brand: products?[index].brand ?? '',
              ),
            );
          },
        ),
      ),
    );
  }
}
