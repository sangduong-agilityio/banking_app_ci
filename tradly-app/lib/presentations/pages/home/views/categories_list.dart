import 'package:flutter/material.dart';
import 'package:tradly_app/data/models/category_model.dart';
import 'package:tradly_app/presentations/widgets/card.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    this.categories,
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;
  final CategoryModel? categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 187,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: onTap,
            child: TACardCategory(
              category: CategoryModel(
                products: [],
                id: categories?.id,
                category: categories?.category,
                imageUrl: categories?.imageUrl ?? '',
              ),
            ),
          );
        },
        itemCount: 8,
      ),
    );
  }
}
