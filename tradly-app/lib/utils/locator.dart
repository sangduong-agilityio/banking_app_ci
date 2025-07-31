import 'package:get_it/get_it.dart';
import 'package:tradly_app/api/api_client.dart';
import 'package:tradly_app/env/env.dart';
import 'package:tradly_app/features/browse/repositories/browse_repo.dart';

final GetIt locator = GetIt.instance;

class AppLocator {
  static Future<void> setup() async {
    locator.registerLazySingleton<TradlyApiClient>(
      () => TradlyApiClient(baseUrl: Env.endPoint),
    );

    locator.registerLazySingleton<BrowseRepository>(
      () => BrowseRepositoryImpl(apiClient: locator<TradlyApiClient>()),
    );
  }
}
