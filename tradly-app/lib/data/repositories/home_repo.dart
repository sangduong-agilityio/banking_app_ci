import 'package:tradly_app/core/api/api_client.dart';
import 'package:tradly_app/core/env/env.dart';
import 'package:tradly_app/data/models/category_model.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/data/models/store_model.dart';

abstract class HomeRepository {
  Future<List<CategoryModel>> fetchCategories();
  Future<List<StoreModel>> fetchStores();
  Future<List<ProductModel>> fetchNewProducts();
  Future<List<ProductModel>> fetchPopularProducts();
}

class HomeRepositoryImpl implements HomeRepository {
  final TradlyApiClient _apiClient;

  HomeRepositoryImpl({
    required TradlyApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    String apiUrl = '${Env.endPoint}categories';

    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': '*',
      },
    );
    final jsonData = response.data;

    final categories =
        (jsonData as List).map((json) => CategoryModel.fromJson(json)).toList();
    return categories;
  }

  @override
  Future<List<StoreModel>> fetchStores() async {
    try {
      final apiUrl = '${Env.endPoint}stores';

      final response = await _apiClient.get(
        apiUrl,
        queryParams: {
          'select': '*',
        },
      );

      final data = response.data;

      if (data is List) {
        return data.map((json) => StoreModel.fromMap(json)).toList();
      } else {
        throw Exception('Invalid response format: expected a List');
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ProductModel>> fetchNewProducts() async {
    final apiUrl = '${Env.endPoint}productType';
    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': '*,productId(*)',
        'tag': 'eq.new',
      },
    );

    final jsonData = response.data;

    return (jsonData as List)
        .map((json) => ProductModel.fromJson(json['productId']))
        .toList();
  }

  @override
  Future<List<ProductModel>> fetchPopularProducts() async {
    final apiUrl = '${Env.endPoint}productType';
    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': '*,productId(*)',
        'tag': 'eq.popular',
      },
    );

    final jsonData = response.data;

    return (jsonData as List)
        .map((json) => ProductModel.fromJson(json['productId']))
        .toList();
  }
}
