import 'package:flutter/material.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/product_list.dart';

class HomeCareList extends StatelessWidget {
  const HomeCareList({
    super.key,
    this.categoryId,
  });

  final int? categoryId;

  @override
  Widget build(BuildContext context) {
    return ProductList(
      title: 'Home Care',
      categoryId: categoryId ?? 0,
    );
  }
}
