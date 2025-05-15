import 'package:equatable/equatable.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/data/models/store_model.dart';

sealed class StoreEvt extends Equatable {
  const StoreEvt();

  @override
  List<Object?> get props => [];
}

class InitializeStoreEvt extends StoreEvt {
  const InitializeStoreEvt();

  @override
  List<Object?> get props => [];
}

class CreateStoreButtonEvt extends StoreEvt {
  const CreateStoreButtonEvt({
    required this.store,
  });

  final StoreModel store;

  @override
  List<Object?> get props => [store];
}

class CreateStoreFormValidateChagedEvt extends StoreEvt {
  const CreateStoreFormValidateChagedEvt(
      {required this.isValidate, this.store});

  final bool isValidate;
  final StoreModel? store;

  @override
  List<Object?> get props => [isValidate, store];
}

class AddProductEvt extends StoreEvt {
  const AddProductEvt({
    required this.product,
  });

  final ProductModel product;

  @override
  List<Object?> get props => [product];
}

class EditProductButtonEvt extends StoreEvt {
  const EditProductButtonEvt({
    required this.product,
  });

  final ProductModel product;

  @override
  List<Object?> get props => [product];
}

class EditFormValidateChangedEvt extends StoreEvt {
  const EditFormValidateChangedEvt({
    required this.isValidate,
    required this.product,
  });

  final bool isValidate;
  final ProductModel product;

  @override
  List<Object?> get props => [isValidate, product];
}

class DeleteProductEvt extends StoreEvt {
  const DeleteProductEvt({
    required this.productId,
  });

  final String productId;

  @override
  List<Object?> get props => [productId];
}

class PickImageEvt extends StoreEvt {
  const PickImageEvt({
    required this.maxPhotos,
  });

  final int maxPhotos;

  @override
  List<Object?> get props => [maxPhotos];
}

class RemoveImageEvt extends StoreEvt {
  const RemoveImageEvt({
    required this.image,
  });

  final int image;

  @override
  List<Object?> get props => [image];
}
