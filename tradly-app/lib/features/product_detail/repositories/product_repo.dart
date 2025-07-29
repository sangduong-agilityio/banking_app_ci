import 'package:tradly_app/api/api_client.dart';
import 'package:tradly_app/env/env.dart';
import 'package:tradly_app/features/home/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> fetchProductsByCategoryId(int categoryId);
  Future<List<ProductModel>> fetchProductById(int productId);
  Future<List<ProductModel>> fetchOrderHistory();
}

class ProductRepositoryImpl implements ProductRepository {
  final TradlyApiClient _apiClient;

  ProductRepositoryImpl({
    required TradlyApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<List<ProductModel>> fetchProductsByCategoryId(int categoryId) async {
    String apiUrl = '${Env.endPoint}products';
    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': 'id,title,price,brand,newPrice,imageUrl,categoryId',
        'categoryId': 'eq.$categoryId',
      },
    );
    final jsonData = response.data;

    final products =
        (jsonData as List).map((json) => ProductModel.fromJson(json)).toList();

    return products;
  }

  @override
  Future<List<ProductModel>> fetchProductById(int productId) async {
    String apiUrl = '${Env.endPoint}products';
    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': '*',
        'id': 'eq.$productId',
      },
    );
    final jsonData = response.data;

    final products =
        (jsonData as List).map((json) => ProductModel.fromJson(json)).toList();

    return products;
  }

  @override
  Future<List<ProductModel>> fetchOrderHistory() async {
    String apiUrl = '${Env.endPoint}orders';
    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': 'id,productId,quantity,status,createdAt',
      },
    );
    final jsonData = response.data;

    final orders =
        (jsonData as List).map((json) => ProductModel.fromJson(json)).toList();

    return orders;
  }
}
