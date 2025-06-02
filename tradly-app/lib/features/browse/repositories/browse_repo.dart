import 'package:tradly_app/api/api_client.dart';
import 'package:tradly_app/env/env.dart';
import 'package:tradly_app/features/home/models/product_model.dart';

abstract class BrowseRepository {
  Future<List<ProductModel>> fetchProducts();
}

class BrowseRepositoryImpl implements BrowseRepository {
  final TradlyApiClient _apiClient;

  BrowseRepositoryImpl({
    required TradlyApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<List<ProductModel>> fetchProducts() async {
    String apiUrl = '${Env.endPoint}products';

    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': 'id,title,imageUrl,price,brand',
      },
    );
    final jsonData = response.data;

    final products =
        (jsonData as List).map((json) => ProductModel.fromJson(json)).toList();
    return products;
  }
}
