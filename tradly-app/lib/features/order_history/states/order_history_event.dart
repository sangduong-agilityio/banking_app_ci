import 'package:equatable/equatable.dart';
import 'package:tradly_app/features/home/models/product_model.dart';

class OrderHistoryEvt extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddProductToOrderHistoryEvt extends OrderHistoryEvt {
  AddProductToOrderHistoryEvt({required this.product});
  final ProductModel product;

  @override
  List<Object?> get props => [product];
}
