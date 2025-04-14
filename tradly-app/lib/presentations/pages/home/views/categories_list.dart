import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/data/models/category_model.dart';
import 'package:tradly_app/presentations/pages/home/states/home_bloc.dart';
import 'package:tradly_app/presentations/pages/home/states/home_state.dart';
import 'package:tradly_app/presentations/widgets/images.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.onCategoryTap,
  });

  final void Function(CategoryModel category)? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status is HomeStatusListLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.categories == null || state.categories!.isEmpty) {
          return const Center(
            child: Text('No categories available'),
          );
        }
        return SizedBox(
          height: 187,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemBuilder: (context, index) {
              final category = state.categories![index];
              return GestureDetector(
                onTap: () => onCategoryTap?.call(category),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TAImageRectangle(
                      category.imageUrl ?? '',
                      width: double.infinity,
                      height: 93,
                      boxFit: BoxFit.cover,
                    ),
                    Container(
                      color: context.colorScheme.onSurface.withAlpha(128),
                    ),
                    TaTitleSmallText(
                      text: category.category ?? '',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
            itemCount: state.categories!.length,
          ),
        );
      },
    );
  }
}
