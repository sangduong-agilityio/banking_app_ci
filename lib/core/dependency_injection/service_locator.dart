import 'package:banking_app/core/api/api_client.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/features/auth/bloc/auth_bloc.dart';
import 'package:banking_app/features/auth/services/auth_repository.dart';
import 'package:banking_app/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:banking_app/features/dashboard/services/dashboard_repository.dart';
import 'package:banking_app/features/search/bloc/search_bloc.dart';
import 'package:banking_app/features/search/services/search_repository.dart';
import 'package:banking_app/features/setting/bloc/setting_cubit.dart';
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
    locator.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImplement(client: Supabase.instance.client),
    );
    locator.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImplement(client: apiClient),
    );

    locator.registerFactory<SettingCubit>(
      () => SettingCubit(repo: locator<AuthRepository>()),
    );

    locator.registerFactory<AuthBloc>(
      () => AuthBloc(repo: locator<AuthRepository>()),
    );
    locator.registerFactory<DashBoardCubit>(
      () => DashBoardCubit(repo: locator<DashboardRepository>()),
    );

    locator.registerFactory<SearchBloc>(
      () => SearchBloc(repo: locator<SearchRepository>()),
    );
  }
}
