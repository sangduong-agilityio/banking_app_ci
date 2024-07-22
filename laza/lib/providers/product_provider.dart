import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/api/api_client.dart';
import 'package:laza/core/env/env.dart';
import 'package:laza/data/repositories/product_repo.dart';

part 'product_provider.g.dart';

@riverpod
LazaApiClient lazaApiClientProvider(LazaApiClientProviderRef ref) {
  return LazaApiClient(baseUrl: Env.supabaseUrl);
}

@riverpod
ProductRepository productRepositoryProvider(ProductRepositoryProviderRef ref) {
  return ProductRepositoryImpl(apiClient: ref.watch(lazaApiClientProvider));
}
