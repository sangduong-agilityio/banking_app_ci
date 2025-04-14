import 'package:flutter/material.dart';
import 'product_list.dart';

class BreadBakeryList extends StatelessWidget {
  const BreadBakeryList({
    super.key,
    this.categoryId,
  });
  final int? categoryId;

  @override
  Widget build(BuildContext context) {
    return ProductList(
      title: 'Bread & Bakery',
      categoryId: categoryId ?? 0,
    );
  }
}
