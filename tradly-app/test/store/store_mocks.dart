import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/store/models/store_model.dart';
import 'package:tradly_app/features/store/repositories/store_repo.dart';

class StoreRepositoryMocks extends Mock implements StoreRepository {}

class MockImagePicker extends Mock implements ImagePicker {}

class StoreMocks {
  static final StoreModel store = StoreModel(
    storeName: 'storeName',
    storeWebAddress: 'storeWebAddress',
    storeDescription: 'storeDescription',
    storeType: 'storeType',
    imageUrl: 'imageUrl',
    address: 'address',
    city: 'city',
    logoStore: 'logoStore',
    country: 'country',
    courieName: 'courieName',
  );

  static final ProductModel product = ProductModel(
    title: 'title',
    imageUrl: 'imageUrl',
    price: 'price',
    brand: 'brand',
    newPrice: 'newPrice',
    description: 'description',
    priceType: 'priceType',
    condition: 'condition',
    location: 'location',
    storeId: 0,
  );
}
