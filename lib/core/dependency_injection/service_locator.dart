import 'package:banking_app/core/api/api_client.dart';
import 'package:banking_app/core/database/objectbox_setup.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/core/services/biometric_service.dart';
import 'package:banking_app/core/services/exchange_rate_cache_service.dart';
import 'package:banking_app/features/account/states/account_and_card_cubit.dart';
import 'package:banking_app/features/auth/repositories/auth_repository.dart';
import 'package:banking_app/features/auth/states/auth_bloc.dart';
import 'package:banking_app/features/bill_payment/repositories/bill_payment_repository.dart';
import 'package:banking_app/features/bill_payment/states/bill_payment_bloc.dart';
import 'package:banking_app/features/home/repositories/home_repository.dart';
import 'package:banking_app/features/home/states/home_cubit.dart';
import 'package:banking_app/features/search/entities/exchange_rate_entity.dart';
import 'package:banking_app/features/search/repositories/search_repository.dart';
import 'package:banking_app/features/search/states/search_bloc.dart';
import 'package:banking_app/features/setting/states/setting_cubit.dart';
import 'package:banking_app/features/transactions/repositories/transaction_repository.dart';
import 'package:banking_app/features/transactions/states/transaction_bloc.dart';
import 'package:banking_app/features/transfer/repositories/transfer_repository.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:objectbox/objectbox.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Global GetIt instance for dependency injection
final GetIt locator = GetIt.instance;

class AppLocators {
  /// Registers all services, repositories, blocs, and cubits
  static Future<void> setupLocators() async {
    /// ObjectBox Store (async init)
    locator.registerSingletonAsync<Store>(() async {
      return await ObjectBoxManager.getStore();
    });

    /// Supabase client
    locator.registerLazySingleton(() => Supabase.instance.client);

    /// API client
    locator.registerLazySingleton<BankingApiClient>(
      () => BankingApiClient(baseUrl: Env.endPoint),
    );

    /// ExchangeRate cache service (needs Store)
    locator.registerSingletonAsync<ExchangeRateCacheService>(() async {
      final store = await locator.getAsync<Store>();
      final exchangeRateBox = store.box<ExchangeRateEntity>();
      return ExchangeRateCacheService(exchangeRateBox);
    }, dependsOn: [Store]);

    /// Biometric service
    locator.registerLazySingleton<BiometricService>(() => BiometricService());

    /// Repositories
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplement(client: locator()),
    );

    locator.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(client: locator()),
    );

    locator.registerSingletonAsync<SearchRepository>(() async {
      final client = locator<BankingApiClient>();
      final cacheService = await locator.getAsync<ExchangeRateCacheService>();
      return SearchRepositoryImplement(
        client: client,
        cacheService: cacheService,
      );
    }, dependsOn: [ExchangeRateCacheService]);

    locator.registerLazySingleton<TransferRepository>(
      () => TransferRepositoryImpl(client: locator()),
    );

    locator.registerLazySingleton<BillPaymentRepository>(
      () => BillPaymentRepositoryImpl(client: locator()),
    );

    locator.registerLazySingleton<TransactionReportRepository>(
      () => TransactionReportRepositoryImpl(client: locator()),
    );

    /// Blocs and Cubits
    locator.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        repo: locator<AuthRepository>(),
        biometricService: locator<BiometricService>(),
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

    locator.registerSingletonAsync<SearchBloc>(() async {
      final repo = await locator.getAsync<SearchRepository>();
      final cacheService = await locator.getAsync<ExchangeRateCacheService>();
      return SearchBloc(repo: repo, cacheService: cacheService);
    }, dependsOn: [SearchRepository, ExchangeRateCacheService]);

    locator.registerFactory<TransferBloc>(
      () => TransferBloc(
        transferRepo: locator<TransferRepository>(),
        biometricService: locator<BiometricService>(),
      ),
    );

    locator.registerFactory<BillPaymentBloc>(
      () => BillPaymentBloc(repository: locator<BillPaymentRepository>()),
    );

    locator.registerLazySingleton<TransactionReportBloc>(
      () => TransactionReportBloc(repo: locator<TransactionReportRepository>()),
    );
  }
}
