import 'package:laza/core/api/api_client.dart';
import 'package:laza/core/env/env.dart';
import 'package:laza/data/models/product_image_model.dart';
import 'package:laza/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({
    String? query,
    int? brandId,
    int? productId,
  });
  Future<List<ProductImage>> getProductImages(int productId);
}

class ProductRepositoryImpl implements ProductRepository {
  final LazaApiClient _apiClient;

  ProductRepositoryImpl({required LazaApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<Product>> getProducts({
    String? query,
    int? brandId,
    int? productId,
  }) async {
    const String apiUrl = '${Env.endPoint}product';

    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': '*',
        if (query != null && query.isNotEmpty) 'name': 'ilike.%$query%',
        if (brandId != null) 'brand_id': 'eq.$brandId',
        if (productId != null) 'product_id': 'eq.$productId',
      },
    );
    final jsonData = response.data;
    final products =
        (jsonData as List).map((json) => Product.fromJson(json)).toList();

    return products;
  }

  @override
  Future<List<ProductImage>> getProductImages(int productId) async {
    const String apiUrl = '${Env.endPoint}product_image';
    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': 'id,imageUrl,productId',
        'productId': 'eq.$productId',
      },
    );
    final jsonData = response.data;

    final productImages =
        (jsonData as List).map((json) => ProductImage.fromJson(json)).toList();

    return productImages;
  }
}
