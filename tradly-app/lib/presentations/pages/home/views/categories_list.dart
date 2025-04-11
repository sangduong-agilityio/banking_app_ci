import 'package:flutter/material.dart';
import 'package:tradly_app/data/models/category_model.dart';
import 'package:tradly_app/presentations/widgets/images.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    this.categories,
    super.key,
    required this.onCategoryTap,
  });

  final void Function(CategoryModel category)? onCategoryTap;
  final List<CategoryModel>? categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 187,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          final category = categories?[index];
          return GestureDetector(
            onTap: () => onCategoryTap?.call(category!),
            child: Stack(
              alignment: Alignment.center,
              children: [
                TAImageRectangle(
                  category?.imageUrl ?? '',
                  width: double.infinity,
                  height: 93,
                  boxFit: BoxFit.cover,
                ),
                TaTitleSmallText(
                  text: category?.category ?? '',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
        itemCount: categories?.length ?? 0,
      ),
    );
  }
}
