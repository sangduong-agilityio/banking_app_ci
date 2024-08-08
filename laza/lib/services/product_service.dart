import 'package:laza/data/models/product_model.dart';
import 'package:laza/data/repositories/product_repo.dart';

class ProductService {
  final ProductRepository _productRepository;

  ProductService({required ProductRepository productRepository})
      : _productRepository = productRepository;

  Future<List<Product>> getProducts(String query,
      {int? brandId, int? productId}) {
    return _productRepository.getProducts(
      query: query,
      productId: productId,
      brandId: brandId,
    );
  }
}
