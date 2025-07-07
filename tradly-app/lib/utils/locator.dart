import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/api/api_client.dart';
import 'package:tradly_app/env/env.dart';
import 'package:tradly_app/features/auth/repositories/auth_repo.dart';
import 'package:tradly_app/features/browse/repositories/browse_repo.dart';
import 'package:tradly_app/features/home/repositories/home_repo.dart';
import 'package:tradly_app/features/product_detail/repositories/product_repo.dart';
import 'package:tradly_app/features/store/repositories/store_repo.dart';

final GetIt locator = GetIt.instance;

class AppLocators {
  static Future<void> setupLocators() async {
    locator.registerLazySingleton<TradlyApiClient>(
      () => TradlyApiClient(
        baseUrl: Env.endPoint,
      ),
    );

    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplement(
        client: SupabaseClient(
          Env.supabaseUrl,
          Env.supabaseKey,
        ),
      ),
    );

    locator.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        apiClient: locator<TradlyApiClient>(),
      ),
    );

    locator.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(
        apiClient: locator<TradlyApiClient>(),
      ),
    );

    locator.registerLazySingleton<StoreRepository>(
      () => StoreRepositoryImpl(
        apiClient: locator<TradlyApiClient>(),
      ),
    );

    locator.registerLazySingleton<BrowseRepository>(
      () => BrowseRepositoryImpl(
        apiClient: locator<TradlyApiClient>(),
      ),
    );
  }
}
