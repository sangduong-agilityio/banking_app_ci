import 'package:flutter/material.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/product_list.dart';

class BeveragesList extends StatelessWidget {
  const BeveragesList({
    super.key,
    this.categoryId,
  });

  final int? categoryId;

  @override
  Widget build(BuildContext context) {
    return ProductList(
      title: 'Beverages',
      categoryId: categoryId ?? 0,
    );
  }
}
