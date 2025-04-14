import 'package:flutter/material.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/product_list.dart';

class PetCareList extends StatelessWidget {
  const PetCareList({
    super.key,
    this.categoryId,
  });

  final int? categoryId;

  @override
  Widget build(BuildContext context) {
    return ProductList(
      title: 'Pet Care',
      categoryId: categoryId ?? 0,
    );
  }
}
