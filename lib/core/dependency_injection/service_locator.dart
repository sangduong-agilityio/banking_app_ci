import 'package:banking_app/core/api/api_client.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/features/auth/states/auth_bloc.dart';
import 'package:banking_app/features/auth/repositories/auth_repository.dart';
import 'package:banking_app/features/home/repositories/home_repository.dart';
import 'package:banking_app/features/home/states/home_cubit.dart';
import 'package:banking_app/features/search/states/search_bloc.dart';
import 'package:banking_app/features/search/repositories/search_repository.dart';
import 'package:banking_app/features/setting/states/setting_cubit.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/repositories/transfer_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt locator = GetIt.instance;
final apiClient = BankingApiClient(baseUrl: Env.endPoint);

class AppLocators {
  static Future<void> setupLocators() async {
    locator.registerLazySingleton<BankingApiClient>(
      () => BankingApiClient(baseUrl: Env.endPoint),
    );

    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplement(client: Supabase.instance.client),
    );
    locator.registerLazySingleton<HomeRepository>(
      () => DashboardRepositoryImplement(client: Supabase.instance.client),
    );
    locator.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImplement(client: apiClient),
    );

    locator.registerLazySingleton<TransferRepository>(
      () => TransferRepositoryImpl(baseUrl: Env.endPoint),
    );

    locator.registerFactory<SettingCubit>(
      () => SettingCubit(repo: locator<AuthRepository>()),
    );

    locator.registerFactory<AuthBloc>(
      () => AuthBloc(repo: locator<AuthRepository>()),
    );
    locator.registerFactory<HomeCubit>(
      () => HomeCubit(repo: locator<HomeRepository>()),
    );

    locator.registerFactory<SearchBloc>(
      () => SearchBloc(repo: locator<SearchRepository>()),
    );

    locator.registerFactory<TransferBloc>(
      () => TransferBloc(repo: locator<TransferRepository>()),
    );
  }
}
