import 'dart:math';

import 'package:tradly_app/api/api_client.dart';
// import 'package:tradly_app/env/env.dart';
import 'package:tradly_app/features/home/models/product_model.dart';

abstract class BrowseRepository {
  Future<List<ProductModel>> fetchProducts({
    int page = 1,
    int limit = 20,
  });
}

// class BrowseRepositoryImpl implements BrowseRepository {
//   final TradlyApiClient _apiClient;

//   BrowseRepositoryImpl({
//     required TradlyApiClient apiClient,
//   }) : _apiClient = apiClient;

//   @override
//   Future<List<ProductModel>> fetchProducts() async {
//     String apiUrl = '${Env.endPoint}products';

//     final response = await _apiClient.get(
//       apiUrl,
//       queryParams: {
//         'select': 'id,title,imageUrl,price,brand',
//       },
//     );
//     final jsonData = response.data;

//     final products =
//         (jsonData as List).map((json) => ProductModel.fromJson(json)).toList();
//     return products;
//   }
// }

class BrowseRepositoryImpl implements BrowseRepository {
  // final TradlyApiClient _apiClient;

  BrowseRepositoryImpl({
    required TradlyApiClient apiClient,
  });
  //  : _apiClient = apiClient;

  @override
  Future<List<ProductModel>> fetchProducts(
      {int page = 1, int limit = 20}) async {
    final faker = Random();
    final allProducts = List.generate(1000, (index) {
      return ProductModel(
        id: index,
        title: 'Product $index',
        imageUrl: 'https://picsum.photos/250?image=9$index',
        price: '100',
        brand: 'Brand ${faker.nextInt(10)}',
      );
    });

    final start = (page - 1) * limit;
    final end = start + limit;

    if (start >= allProducts.length) {
      return [];
    }

    return allProducts.sublist(start, end.clamp(0, allProducts.length));
  }
}
