import 'package:laza/core/api/api_client.dart';
import 'package:laza/core/env/env.dart';
import 'package:laza/data/models/brand_model.dart';
import 'package:laza/data/repositories/brand_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brand_provider.g.dart';

@Riverpod(keepAlive: true)
LazaApiClient lazaApiClient(LazaApiClientRef ref) {
  return LazaApiClient(baseUrl: Env.supabaseUrl);
}

@Riverpod(keepAlive: true)
BrandRepository brandRepository(BrandRepositoryRef ref) {
  return BrandRepositoryImpl(apiClient: ref.watch(lazaApiClientProvider));
}

@Riverpod(keepAlive: true)
Future<List<Brand>> brand(FutureProviderRef<List<Brand>> ref) async {
  final brandRepository = ref.watch(brandRepositoryProvider);
  return brandRepository.getBrands();
}
