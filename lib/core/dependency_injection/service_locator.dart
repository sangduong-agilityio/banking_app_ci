import 'package:banking_app/core/data/services/api/api_client.dart';
import 'package:banking_app/core/data/database/objectbox_setup.dart';
import 'package:banking_app/core/data/services/graphql/graphql_client.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/data/services/biometric_service.dart';
import 'package:banking_app/core/data/services/currency_cache_service.dart';
import 'package:banking_app/core/data/services/exchange_rate_cache_service.dart';
import 'package:banking_app/core/data/services/offline_exchange_service.dart';
import 'package:banking_app/core/data/services/exchange_cache_manager.dart';
import 'package:banking_app/core/data/services/connectivity_service.dart';

import 'package:banking_app/features/account/presentation/blocs/account_and_card_cubit.dart';
import 'package:banking_app/features/auth/data/repositories/auth_repository.dart';
import 'package:banking_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:banking_app/features/bill_payment/data/repositories/bill_payment_repository.dart';
import 'package:banking_app/features/bill_payment/presentation/blocs/bill_payment_bloc.dart';
import 'package:banking_app/features/home/data/repositories/home_repository.dart';
import 'package:banking_app/features/home/presentation/blocs/home_cubit.dart';
import 'package:banking_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:banking_app/features/search/domain/entities/currency_rate_entity.dart';
import 'package:banking_app/features/search/domain/entities/exchange_rate_entity.dart';
import 'package:banking_app/features/search/domain/repositories/search_repository.dart';
import 'package:banking_app/features/search/presentation/blocs/search_bloc.dart';
import 'package:banking_app/features/setting/presentation/blocs/setting_cubit.dart';
import 'package:banking_app/features/transactions/data/repositories/transaction_repository.dart';
import 'package:banking_app/features/transactions/data/repositories/graphql_transaction_repository.dart';
import 'package:banking_app/features/transactions/presentation/blocs/transaction_bloc.dart';
import 'package:banking_app/features/transactions/presentation/blocs/graphql/graphql_transaction_bloc.dart';
import 'package:banking_app/features/transfer/data/repositories/transfer_repository.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:objectbox/objectbox.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt locator = GetIt.instance;

class AppLocators {
  static Future<void> setupLocators() async {
    /// Async initializations
    locator.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance(),
    );

    locator.registerSingletonAsync<Store>(() => ObjectBoxManager.getStore());

    /// Synchronous registrations that depend on async ones
    locator.registerSingletonAsync<ConnectivityService>(
      () => Future.value(ConnectivityService()),
    );

    /// Wait for async singletons to be ready
    await locator.allReady();

    final store = locator<Store>();

    /// Synchronous registrations
    locator.registerLazySingleton(() => Supabase.instance.client);

    locator.registerLazySingleton<BankingApiClient>(
      () => BankingApiClient(baseUrl: Env.endPoint),
    );

    /// Services
    locator.registerLazySingleton<ExchangeRateCacheService>(
      () => ExchangeRateCacheService(store.box<ExchangeRateEntity>()),
    );

    locator.registerLazySingleton<OfflineExchangeService>(
      () => OfflineExchangeService(store.box<CurrencyRateEntity>()),
    );

    locator.registerLazySingleton<CurrencyCacheService>(
      () => CurrencyCacheService(
        store.box<CurrencyEntity>(),
        store.box<CurrencyRateEntity>(),
      ),
    );

    locator.registerLazySingleton<ExchangeCacheManager>(
      () => ExchangeCacheManager(
        rateCache: locator<ExchangeRateCacheService>(),
        offlineCache: locator<OfflineExchangeService>(),
        currencyCache: locator<CurrencyCacheService>(),
      ),
    );

    locator.registerLazySingleton<BiometricService>(() => BiometricService());

    /// Repositories
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplement(client: locator()),
    );

    locator.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(client: locator()),
    );

    locator.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(
        client: locator<BankingApiClient>(),
        cacheManager: locator<ExchangeCacheManager>(),
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

    /// Blocs / Cubits
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
        cacheManager: locator<ExchangeCacheManager>(),
        connectivityStream:
            locator<ConnectivityService>().connectionStatusStream,
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

    // GraphQL Client
    locator.registerLazySingleton<BankingGraphQLClient>(
      () => BankingGraphQLClient(),
    );

    // GraphQL Repository
    locator.registerLazySingleton<GraphQLTransactionRepository>(
      () => GraphQLTransactionRepositoryImpl(
        client: locator<BankingGraphQLClient>(),
      ),
    );

    // GraphQL BLoC
    locator.registerFactory<GraphQLTransactionBloc>(
      () => GraphQLTransactionBloc(
        repository: locator<GraphQLTransactionRepository>(),
      ),
    );
  }
}
