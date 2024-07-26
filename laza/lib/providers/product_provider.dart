import 'package:laza/core/api/api_client.dart';
import 'package:laza/core/env/env.dart';
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
