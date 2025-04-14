import 'package:flutter/material.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/product_list.dart';

class FruitList extends StatelessWidget {
  const FruitList({
    super.key,
    this.categoryId,
  });

  final int? categoryId;

  @override
  Widget build(BuildContext context) {
    return ProductList(
      title: 'Fruit',
      categoryId: categoryId ?? 0,
    );
  }
}
