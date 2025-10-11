import 'package:banking_app/core/api/api_client.dart';
import 'package:banking_app/core/database/objectbox_setup.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/core/services/biometric_service.dart';
import 'package:banking_app/core/services/exchange_rate_cache_service.dart';
import 'package:banking_app/core/services/offline_exchange_service.dart';
import 'package:banking_app/features/account/blocs/account_and_card_cubit.dart';
import 'package:banking_app/features/auth/repositories/auth_repository.dart';
import 'package:banking_app/features/auth/blocs/auth_bloc.dart';
import 'package:banking_app/features/bill_payment/repositories/bill_payment_repository.dart';
import 'package:banking_app/features/bill_payment/blocs/bill_payment_bloc.dart';
import 'package:banking_app/features/home/repositories/home_repository.dart';
import 'package:banking_app/features/home/blocs/home_cubit.dart';
import 'package:banking_app/features/search/entities/currency_rate_entity.dart';
import 'package:banking_app/features/search/entities/exchange_rate_entity.dart';
import 'package:banking_app/features/search/repositories/search_repository.dart';
import 'package:banking_app/features/search/blocs/search_bloc.dart';
import 'package:banking_app/features/setting/blocs/setting_cubit.dart';
import 'package:banking_app/features/transactions/repositories/transaction_repository.dart';
import 'package:banking_app/features/transactions/blocs/transaction_bloc.dart';
import 'package:banking_app/features/transfer/repositories/transfer_repository.dart';
import 'package:banking_app/features/transfer/blocs/transfer_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:objectbox/objectbox.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Global GetIt instance for dependency injection
final GetIt locator = GetIt.instance;

class AppLocators {
  /// Registers all services, repositories, blocs, and cubits
  static Future<void> setupLocators() async {
    /// ASYNC registrations
    locator.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance(),
    );

    /// Initialize Store first and wait for it to be ready
    locator.registerSingletonAsync<Store>(() async {
      return await ObjectBoxManager.getStore();
    });

    /// Wait for all async singletons to be ready
    await locator.allReady();

    /// Get the Store instance
    final store = locator<Store>();

    /// Sync registrations
    locator.registerLazySingleton(() => Supabase.instance.client);

    locator.registerLazySingleton<BankingApiClient>(
      () => BankingApiClient(baseUrl: Env.endPoint),
    );

    /// Services - SYNC
    locator.registerLazySingleton<ExchangeRateCacheService>(
      () => ExchangeRateCacheService(store.box<ExchangeRateEntity>()),
    );

    locator.registerLazySingleton<OfflineExchangeService>(
      () => OfflineExchangeService(store.box<CurrencyRateEntity>()),
    );

    locator.registerLazySingleton<BiometricService>(() => BiometricService());

    /// Repositories - SYNC
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplement(client: locator()),
    );

    locator.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(client: locator()),
    );

    locator.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImplement(
        client: locator<BankingApiClient>(),
        cacheService: locator<ExchangeRateCacheService>(),
        offlineService: locator<OfflineExchangeService>(),
      ),
    );

    locator.registerLazySingleton<TransferRepository>(
      () => TransferRepositoryImpl(client: locator()),
    );

    locator.registerLazySingleton<BillPaymentRepository>(
      () => BillPaymentRepositoryImpl(client: locator()),
    );

    locator.registerLazySingleton<TransactionReportRepository>(
      () => TransactionReportRepositoryImpl(client: locator()),
    );

    /// Blocs and Cubits - FACTORY
    locator.registerFactory<AuthBloc>(
      () => AuthBloc(
        repo: locator<AuthRepository>(),
        biometricService: locator<BiometricService>(),
        prefs: locator<SharedPreferences>(),
      ),
    );

    locator.registerFactory<SettingCubit>(
      () => SettingCubit(
        repo: locator<AuthRepository>(),
        biometricService: locator<BiometricService>(),
      ),
    );

    locator.registerFactory<HomeCubit>(
      () => HomeCubit(repo: locator<HomeRepository>()),
    );

    locator.registerFactory<AccountAndCardCubit>(
      () => AccountAndCardCubit(repo: locator<HomeRepository>()),
    );

    locator.registerFactory<SearchBloc>(
      () => SearchBloc(
        repo: locator<SearchRepository>(),
        cacheService: locator<ExchangeRateCacheService>(),
        offlineService: locator<OfflineExchangeService>(),
      ),
    );

    locator.registerFactory<TransferBloc>(
      () => TransferBloc(
        transferRepo: locator<TransferRepository>(),
        biometricService: locator<BiometricService>(),
      ),
    );

    locator.registerFactory<BillPaymentBloc>(
      () => BillPaymentBloc(repository: locator<BillPaymentRepository>()),
    );

    locator.registerFactory<TransactionReportBloc>(
      () => TransactionReportBloc(repo: locator<TransactionReportRepository>()),
    );
  }
}
