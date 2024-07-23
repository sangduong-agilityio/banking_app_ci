import 'package:laza/core/api/api_client.dart';
import 'package:laza/core/env/env.dart';
import 'package:laza/data/models/brand_model.dart';

abstract class BrandRepository {
  Future<List<Brand>> getBrands();
  Future<Brand> getBrandByID(int id);
}

class BrandRepositoryImpl implements BrandRepository {
  final LazaApiClient _apiClient;
  BrandRepositoryImpl({
    required LazaApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<Brand> getBrandByID(int id) async {
    final response = await _apiClient.get('brands/$id');
    final jsonData = response.data;
    return Brand.fromJson(jsonData);
  }

  @override
  Future<List<Brand>> getBrands() async {
    const String apiUrl = '${Env.endPoint}brands';

    final response = await _apiClient.get(
      apiUrl,
      queryParams: {
        'select': '*',
      },
    );
    final jsonData = response.data;

    final brands =
        (jsonData as List).map((json) => Brand.fromJson(json)).toList();
    return brands;
  }
}
