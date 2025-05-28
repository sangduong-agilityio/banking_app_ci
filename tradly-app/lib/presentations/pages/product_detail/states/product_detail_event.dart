import 'package:equatable/equatable.dart';
import 'package:tradly_app/data/models/product_model.dart';

class ProductDetailEvt extends Equatable {
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

final class ProductDetailGetCurrentLocationEvt extends ProductDetailEvt {
  const ProductDetailGetCurrentLocationEvt();

  @override
  List<Object> get props => [];
}

final class ProductDetailAddAddressEvt extends ProductDetailEvt {
  const ProductDetailAddAddressEvt({
    this.product,
  });

  final ProductModel? product;

  @override
  List<Object> get props => [];
}

final class ProductDetailFormValidateChangedEvt extends ProductDetailEvt {
  const ProductDetailFormValidateChangedEvt({
    required this.isValidate,
    this.product,
  });

  final bool isValidate;
  final ProductModel? product;

  @override
  List<Object> get props => [
        isValidate,
        if (product != null) product!,
      ];
}

final class ProductDetailCheckoutEvt extends ProductDetailEvt {
  const ProductDetailCheckoutEvt({
    required this.product,
  });

  final ProductModel product;

  @override
  List<Object> get props => [product];
}
