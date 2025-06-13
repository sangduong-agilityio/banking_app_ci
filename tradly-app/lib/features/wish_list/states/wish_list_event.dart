import 'package:equatable/equatable.dart';
import 'package:tradly_app/features/home/models/product_model.dart';

class WishListEvt extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWishListEvt extends WishListEvt {
  @override
  List<Object?> get props => [];
}

class AddToWishListEvt extends WishListEvt {
  AddToWishListEvt({
    required this.product,
  });

  final ProductModel product;

  @override
  List<Object?> get props => [product];
}

class RemoveFromWishListEvent extends WishListEvt {
  final ProductModel product;

  RemoveFromWishListEvent({
    required this.product,
  });

  @override
  List<Object?> get props => [product];
}
