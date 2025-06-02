import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradly_app/features/home/models/product_model.dart';

part 'product_detail_state.freezed.dart';

final class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.products,
    this.product,
    this.status = const ProductDetailStatus.initial(),
    this.errorMessage,
    this.hasAddress = false,
    this.isFormValid = false,
  });

  final ProductDetailStatus status;
  final String? errorMessage;
  final List<ProductModel>? products;
  final ProductModel? product;
  final bool hasAddress;
  final bool isFormValid;

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    String? errorMessage,
    List<ProductModel>? products,
    ProductModel? product,
    Set<int>? wishlist,
    bool? hasAddress,
    bool? isFormValid,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
      product: product ?? this.product,
      hasAddress: hasAddress ?? this.hasAddress,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        products,
        product,
        hasAddress,
        isFormValid,
      ];
}

@freezed
sealed class ProductDetailStatus with _$ProductDetailStatus {
  const factory ProductDetailStatus.initial() = ProductDetailStatusInitial;
  const factory ProductDetailStatus.loading() = ProductDetailStatusLoading;
  const factory ProductDetailStatus.success() = ProductDetailStatusSuccess;
  const factory ProductDetailStatus.failure() = ProductDetailStatusFailure;
}
