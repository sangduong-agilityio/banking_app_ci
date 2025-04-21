import 'package:equatable/equatable.dart';
import 'package:tradly_app/data/models/product_model.dart';

sealed class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object?> get props => [];
}

class StoreInitializeEvt extends StoreEvent {}

class CreateStoreEvent extends StoreEvent {
  final String storeName;
  final String description;
  final String webAddress;
  final String storeType;
  final String address;
  final String city;
  final String country;
  final String courierName;
  final String tagLine;

  const CreateStoreEvent(
      {required this.storeName,
      required this.description,
      required this.webAddress,
      required this.storeType,
      required this.address,
      required this.city,
      required this.courierName,
      required this.tagLine,
      required this.country});

  @override
  List<Object?> get props => [
        storeName,
        description,
        webAddress,
        storeType,
        address,
        city,
        courierName,
        country,
        tagLine
      ];
}

class AddProductEvent extends StoreEvent {
  final ProductModel product;

  const AddProductEvent({required this.product});

  @override
  List<Object?> get props => [product];
}

class EditProductEvent extends StoreEvent {
  final ProductModel product;

  const EditProductEvent({required this.product});

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends StoreEvent {
  final String productId;

  const DeleteProductEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class DeleteStoreEvent extends StoreEvent {
  final String storeId;

  const DeleteStoreEvent({required this.storeId});

  @override
  List<Object?> get props => [storeId];
}
