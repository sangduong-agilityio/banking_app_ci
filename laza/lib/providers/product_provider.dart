import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/api/api_client.dart';
import 'package:laza/core/env/env.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/data/repositories/product_repo.dart';
import 'package:laza/services/product_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_provider.g.dart';

@Riverpod(keepAlive: true)
LazaApiClient lazaApiClient(LazaApiClientRef ref) {
  return LazaApiClient(baseUrl: Env.supabaseUrl);
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepositoryImpl(apiClient: ref.watch(lazaApiClientProvider));
}

@Riverpod(keepAlive: true)
ProductService productService(ProductServiceRef ref) {
  return ProductService(
      productRepository: ref.watch(productRepositoryProvider));
}

final sortProvider = StateProvider<SortType>((ref) => SortType.priceLowToHigh);

enum SortType {
  priceLowToHigh,
  priceHighToLow,
}

@Riverpod(keepAlive: true)
class ProductsNotifier extends _$ProductsNotifier {
  late final ProductService _productService;

  @override
  Future<List<Product>> build() async {
    _productService = ref.watch(productServiceProvider);
    return _productService.getProducts();
  }

  void search(String query) {
    final products = state.valueOrNull ?? [];
    final searchedProducts = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    state = AsyncValue.data(searchedProducts);
  }

  void sortProducts(SortType sortType) {
    final products = state.valueOrNull ?? [];
    switch (sortType) {
      case SortType.priceLowToHigh:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.priceHighToLow:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
    state = AsyncValue.data(products);
  }
}

@Riverpod(keepAlive: true)
class SearchProductsNotifier extends _$SearchProductsNotifier {
  late final ProductService _productService;

  @override
  Future<List<Product>> build(String query) async {
    _productService = ref.watch(productServiceProvider);
    return _productService.searchProducts(query);
  }
}
