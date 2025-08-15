import 'package:banking_app/core/api/api_client.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

class AppLocator {
  static Future<void> setup() async {
    locator.registerLazySingleton<BankingApiClient>(
      () => BankingApiClient(baseUrl: Env.endPoint),
    );
  }
}
