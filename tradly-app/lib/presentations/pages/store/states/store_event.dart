import 'package:equatable/equatable.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/data/models/store_model.dart';

sealed class StoreEvt extends Equatable {
  const StoreEvt();

  @override
  List<Object?> get props => [];
}

class CreateStoreEvt extends StoreEvt {
  final StoreModel store;

  const CreateStoreEvt({
    required this.store,
  });

  @override
  List<Object?> get props => [store];
}

class AddProductEvt extends StoreEvt {
  final ProductModel product;

  const AddProductEvt({
    required this.product,
  });

  @override
  List<Object?> get props => [product];
}

class EditProductEvt extends StoreEvt {
  final ProductModel product;

  const EditProductEvt({
    required this.product,
  });

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvt extends StoreEvt {
  const DeleteProductEvt({
    required this.productId,
  });
  final String productId;

  @override
  List<Object?> get props => [productId];
}

class DeleteStoreEvt extends StoreEvt {
  const DeleteStoreEvt({
    required this.storeId,
  });

  final String storeId;

  @override
  List<Object?> get props => [storeId];
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
    required this.index,
  });

  final int index;
  @override
  List<Object?> get props => [index];
}

class EditProductPickImageEvt extends StoreEvt {
  final int maxPhotos;

  const EditProductPickImageEvt({required this.maxPhotos});

  @override
  List<Object?> get props => [maxPhotos];
}
