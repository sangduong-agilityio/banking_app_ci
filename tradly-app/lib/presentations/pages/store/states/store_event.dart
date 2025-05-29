import 'package:equatable/equatable.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/data/models/store_model.dart';

class StoreEvt extends Equatable {
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

class CreateStoreFormValidateChangedEvt extends StoreEvt {
  const CreateStoreFormValidateChangedEvt({
    required this.isValidate,
    this.store,
  });

  final bool isValidate;
  final StoreModel? store;

  @override
  List<Object?> get props => [isValidate, store];
}

class AddProductButtonEvt extends StoreEvt {
  const AddProductButtonEvt({
    required this.product,
  });

  final ProductModel product;

  @override
  List<Object?> get props => [product];
}

class AddProductFormValidateChangedEvt extends StoreEvt {
  const AddProductFormValidateChangedEvt({
    required this.isValidate,
    this.products,
  });

  final bool isValidate;
  final List<ProductModel>? products;

  @override
  List<Object?> get props => [products, isValidate];
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
  final ProductModel? product;

  @override
  List<Object?> get props => [isValidate, product];
}

class DeleteProductEvt extends StoreEvt {
  const DeleteProductEvt({
    required this.productId,
  });

  final int productId;

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

class InitializeEditProductEvt extends StoreEvt {
  const InitializeEditProductEvt({
    required this.product,
  });

  final ProductModel product;

  @override
  List<Object?> get props => [product];
}
