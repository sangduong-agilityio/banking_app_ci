import 'package:tradly_app/api/api_client.dart';
import 'package:tradly_app/env/env.dart';
import 'package:tradly_app/features/home/models/banner_model.dart';
import 'package:tradly_app/features/home/models/category_model.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/store/models/store_model.dart';

abstract class HomeRepository {
  Future<List<BannerModel>> fetchBanners();
  Future<List<CategoryModel>> fetchCategories();
  Future<List<StoreModel>> fetchStores();
  Future<List<ProductModel>> fetchNewProducts();
  Future<List<ProductModel>> fetchPopularProducts();
}

class HomeRepositoryImpl implements HomeRepository {
  final TradlyApiClient _apiClient;

  HomeRepositoryImpl({required TradlyApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<BannerModel>> fetchBanners() {
    return _fetchList<BannerModel>(
      endpoint: 'banners',
      fromJson: BannerModel.fromJson,
    );
  }

  @override
  Future<List<CategoryModel>> fetchCategories() {
    return _fetchList<CategoryModel>(
      endpoint: 'categories',
      fromJson: CategoryModel.fromJson,
    );
  }

  @override
  Future<List<StoreModel>> fetchStores() {
    return _fetchList<StoreModel>(
      endpoint: 'stores',
      fromJson: StoreModel.fromJson,
      handleError: true,
    );
  }

  @override
  Future<List<ProductModel>> fetchNewProducts() {
    return _fetchProductTypeList(tag: 'new');
  }

  @override
  Future<List<ProductModel>> fetchPopularProducts() {
    return _fetchProductTypeList(tag: 'popular');
  }

  /// Generic fetcher for endpoints returning a List<T>
  Future<List<T>> _fetchList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    bool handleError = false,
  }) async {
    final apiUrl = '${Env.endPoint}$endpoint';
    try {
      final response = await _apiClient.get(
        apiUrl,
        queryParams: {'select': '*'},
      );

      final data = response.data;

      if (data is List) {
        return data.map((json) => fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format: expected List');
      }
    } catch (e) {
      if (handleError) {
        return [];
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> _fetchProductTypeList(
      {required String tag}) async {
    final apiUrl = '${Env.endPoint}productType';

    try {
      final response = await _apiClient.get(
        apiUrl,
        queryParams: {
          'select': '*,productId(*)',
          'tag': 'eq.$tag',
        },
      );

      final data = response.data;

      if (data is List) {
        return data
            .map((json) => ProductModel.fromJson(json['productId']))
            .toList();
      } else {
        throw Exception('Invalid productType response format');
      }
    } catch (e) {
      return [];
    }
  }
}
