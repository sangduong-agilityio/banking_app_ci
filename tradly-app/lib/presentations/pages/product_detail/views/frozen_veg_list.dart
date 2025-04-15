import 'package:flutter/material.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/product_list.dart';

class FrozenVegList extends StatelessWidget {
  const FrozenVegList({
    super.key,
    this.categoryId,
  });

  final int? categoryId;

  @override
  Widget build(BuildContext context) {
    return ProductList(
      title: 'Frozen Veg',
      categoryId: categoryId ?? 0,
    );
  }
}
