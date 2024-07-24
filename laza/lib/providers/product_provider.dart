import 'package:laza/core/api/api_client.dart';
import 'package:laza/core/env/env.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:laza/data/repositories/product_repo.dart';

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
Future<List<Product>> products(ProductsRef ref) async {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getProducts();
}

@Riverpod(keepAlive: true)
Future<Product> product(FutureProviderRef<Product> ref) async {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getProductById(3);
}

@Riverpod(keepAlive: true)
Future<List<Product>> searchProducts(
    SearchProductsRef ref, String query) async {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.searchProducts(query);
}
