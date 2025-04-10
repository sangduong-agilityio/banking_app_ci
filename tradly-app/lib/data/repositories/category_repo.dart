import 'package:tradly_app/core/api/api_client.dart';
import 'package:tradly_app/core/env/env.dart';
import 'package:tradly_app/data/models/category_model.dart';
import 'package:tradly_app/data/models/product_model.dart';

abstract class CategoryRepository {
  Future<CategoryModel> fetchCategoryById(int id);
  Future<List<CategoryModel>> fetchCategories();
  Future<List<ProductModel>> fetchProductsByCategoryId(int categoryId);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final TradlyApiClient _apiClient;

  CategoryRepositoryImpl({
    required TradlyApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<CategoryModel> fetchCategoryById(int id) async {
    final response = await _apiClient.get('${Env.endPoint}categories/$id');
    final jsonData = response.data;
    return CategoryModel.fromJson(jsonData);
  }

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
  Future<List<ProductModel>> fetchProductsByCategoryId(int categoryId) async {
    final response = await _apiClient.get('/categories/$categoryId/products');
    final List<dynamic> jsonData = response.data;

    return jsonData
        .map((productJson) => ProductModel.fromJson(productJson))
        .toList();
  }
}
