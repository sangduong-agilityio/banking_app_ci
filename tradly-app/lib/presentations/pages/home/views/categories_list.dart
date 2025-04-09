import 'package:flutter/material.dart';
import 'package:tradly_app/data/models/category_model.dart';
import 'package:tradly_app/presentations/widgets/card.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.category,
    this.onTap,
  });

  final CategoryModel category;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 187,
      width: double.infinity,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          mainAxisExtent: 99,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: onTap,
            child: TACardCategory(
              category: category,
            ),
          );
        },
        itemCount: 8,
      ),
    );
  }
}
