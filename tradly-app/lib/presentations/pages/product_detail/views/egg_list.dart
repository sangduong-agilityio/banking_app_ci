import 'package:flutter/material.dart';
import 'product_list.dart';

class EggList extends StatelessWidget {
  const EggList({
    super.key,
    this.categoryId,
  });

  final int? categoryId;

  @override
  Widget build(BuildContext context) {
    return ProductList(
      title: 'Egg',
      categoryId: categoryId ?? 0,
    );
  }
}
