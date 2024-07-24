import 'package:laza/core/api/api_client.dart';
import 'package:laza/core/env/env.dart';
import 'package:laza/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(int id);
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<List<Product>> searchProducts(String query);
}

class ProductRepositoryImpl implements ProductRepository {
  final LazaApiClient _apiClient;

  ProductRepositoryImpl({required LazaApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<Product>> getProducts() async {
    const String apiUrl = '${Env.endPoint}products';

    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': '*',
      },
    );
    final jsonData = response.data;
    final products =
        (jsonData as List).map((json) => Product.fromJson(json)).toList();
    return products;
  }

  @override
  Future<Product> getProductById(int id) async {
    final response = await _apiClient.get('products/$id');
    final jsonData = response.data;
    return Product.fromJson(jsonData);
  }

  @override
  Future<void> createProduct(Product product) async {
    await _apiClient.post('products', data: product.toJson());
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _apiClient.patch('products/${product.id}', data: product.toJson());
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final response = await _apiClient.get(
      'products',
      queryParams: {
        'select': '*',
        'name': query,
      },
    );

    final jsonData = response.data;
    final products =
        (jsonData as List).map((json) => Product.fromJson(json)).toList();
    return products;
  }
}
