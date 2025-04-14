import 'package:tradly_app/core/api/api_client.dart';
import 'package:tradly_app/core/env/env.dart';
import 'package:tradly_app/data/models/category_model.dart';
import 'package:tradly_app/data/models/product_model.dart';

abstract class HomeRepository {
  Future<List<CategoryModel>> fetchCategories();
  Future<List<ProductModel>> fetchProductsWithTypes();
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
  Future<List<ProductModel>> fetchProductsWithTypes() async {
    String apiUrl = '${Env.endPoint}product_types';

    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': 'id,productId,type',
      },
    );
    final jsonData = response.data;
    final products =
        (jsonData as List).map((json) => ProductModel.fromJson(json)).toList();
    return products;
  }
}
