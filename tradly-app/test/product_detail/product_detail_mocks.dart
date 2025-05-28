import 'package:mocktail/mocktail.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/data/repositories/product_repo.dart';

class ProductDetailRepositoryMocks extends Mock implements ProductRepository {}

class ProductDetailMocks {
  static final ProductModel product = ProductModel(
    id: 1,
    title: 'Test Product',
    description: 'This is a test product.',
    price: '100',
    imageUrl: 'https://example.com/test-product.jpg',
    categoryId: 1,
    location: 'Test Location',
  );
}
