import 'package:equatable/equatable.dart';
import 'package:tradly_app/data/models/category_model.dart';

class HomeState extends Equatable {
  const HomeState({
    this.categories,
  });

  final HomeCategoryState? categories;

  HomeState copyWith({
    HomeCategoryState? categories,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        categories,
      ];
}

class HomeInitialState extends HomeState {
  @override
  List<Object?> get props => [];
}

/// Category State
class HomeCategoryState extends HomeState {
  const HomeCategoryState({
    this.isLoading = false,
    this.error,
    this.courseCategories,
  });

  final bool isLoading;
  final String? error;

  final List<CategoryModel>? courseCategories;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        courseCategories,
      ];
}
