import 'package:equatable/equatable.dart';

sealed class ProductDetailEvt extends Equatable {
  const ProductDetailEvt();

  @override
  List<Object> get props => [];
}

final class ProductDetailInitializeEvt extends ProductDetailEvt {
  const ProductDetailInitializeEvt({
    required this.categoryId,
  });

  final int categoryId;

  @override
  List<Object> get props => [categoryId];
}

final class ProductDetailFetchEvt extends ProductDetailEvt {
  const ProductDetailFetchEvt({
    required this.productId,
  });

  final int productId;

  @override
  List<Object> get props => [productId];
}
