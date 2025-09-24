import 'package:banking_app/core/api/api_client.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/core/services/biometric_service.dart';
import 'package:banking_app/features/account/states/account_and_card_cubit.dart';
import 'package:banking_app/features/auth/repositories/auth_repository.dart';
import 'package:banking_app/features/auth/states/auth_bloc.dart';
import 'package:banking_app/features/home/repositories/home_repository.dart';
import 'package:banking_app/features/home/states/home_cubit.dart';
import 'package:banking_app/features/search/repositories/search_repository.dart';
import 'package:banking_app/features/search/states/search_bloc.dart';
import 'package:banking_app/features/setting/states/setting_cubit.dart';
import 'package:banking_app/features/transfer/repositories/transfer_repository.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Global GetIt instance for dependency injection
final GetIt locator = GetIt.instance;

class AppLocators {
  /// Registers all services, repositories, blocs, and cubits
  static Future<void> setupLocators() async {
    locator.registerLazySingleton<BankingApiClient>(
      () => BankingApiClient(baseUrl: Env.endPoint),
    );

    locator.registerLazySingleton<BiometricService>(() => BiometricService());

    /// Repositories
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplement(client: Supabase.instance.client),
    );

    locator.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(client: Supabase.instance.client),
    );

    locator.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImplement(client: locator<BankingApiClient>()),
    );

    locator.registerLazySingleton<TransferRepository>(
      () => TransferRepositoryImpl(client: Supabase.instance.client),
    );

    /// Blocs / Cubits
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

    locator.registerFactory<SearchBloc>(
      () => SearchBloc(repo: locator<SearchRepository>()),
    );

    locator.registerFactory<TransferBloc>(
      () => TransferBloc(
        transferRepo: locator<TransferRepository>(),
        biometricService: locator<BiometricService>(),
      ),
    );
  }
}
