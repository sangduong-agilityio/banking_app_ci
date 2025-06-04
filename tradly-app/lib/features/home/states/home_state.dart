import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradly_app/features/home/models/banner_model.dart';
import 'package:tradly_app/features/home/models/category_model.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/store/models/store_model.dart';

part 'home_state.freezed.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.banners,
    this.categories,
    this.stores,
    this.newProducts,
    this.popularProducts,
    this.status = const HomeStatus.initial(),
    this.errorMessage,
  });
  final HomeStatus status;
  final String? errorMessage;
  final List<BannerModel>? banners;
  final List<CategoryModel>? categories;
  final List<ProductModel>? newProducts;
  final List<ProductModel>? popularProducts;
  final List<StoreModel>? stores;

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    List<BannerModel>? banners,
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    List<ProductModel>? newProducts,
    List<ProductModel>? popularProducts,
    List<StoreModel>? stores,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      newProducts: newProducts ?? this.newProducts,
      popularProducts: popularProducts ?? this.popularProducts,
      stores: stores ?? this.stores,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        banners,
        categories,
        newProducts,
        popularProducts,
        stores,
      ];
}

@freezed
sealed class HomeStatus with _$HomeStatus {
  const factory HomeStatus.initial() = HomeStatusInitial;
  const factory HomeStatus.loading() = HomeStatusLoading;
  const factory HomeStatus.success() = HomeStatusSuccess;
  const factory HomeStatus.failure() = HomeStatusFailure;
}
