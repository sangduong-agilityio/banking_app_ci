import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradly_app/data/models/product_model.dart';

part 'product_detail_state.freezed.dart';

final class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.products,
    this.status = const ProductDetailStatus.initial(),
    this.errorMessage,
  });
  final ProductDetailStatus status;
  final String? errorMessage;
  final List<ProductModel>? products;
  ProductDetailState copyWith({
    ProductDetailStatus? status,
    String? errorMessage,
    List<ProductModel>? products,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, products];
}

@freezed
sealed class ProductDetailStatus with _$ProductDetailStatus {
  const factory ProductDetailStatus.initial() = ProductDetailStatusListInitial;
  const factory ProductDetailStatus.loading() = ProductDetailStatusListLoading;
  const factory ProductDetailStatus.success() = ProductDetailStatusListSuccess;
  const factory ProductDetailStatus.failure() = ProductDetailStatusListFailure;
}
