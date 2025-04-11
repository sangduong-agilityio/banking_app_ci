import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradly_app/data/models/category_model.dart';

part 'home_state.freezed.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.categories,
    this.status = const HomeStatus.initial(),
    this.errorMessage,
  });
  final HomeStatus status;
  final String? errorMessage;
  final List<CategoryModel>? categories;
  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    List<CategoryModel>? categories,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, categories];
}

@freezed
sealed class HomeStatus with _$HomeStatus {
  const factory HomeStatus.initial() = HomeStatusListInitial;
  const factory HomeStatus.loading() = HomeStatusListLoading;
  const factory HomeStatus.success() = HomeStatusListSuccess;
  const factory HomeStatus.failure() = HomeStatusListFailure;
}
