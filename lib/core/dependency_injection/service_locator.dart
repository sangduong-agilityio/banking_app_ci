import 'package:banking_app/core/api/api_client.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/features/auth/bloc/auth_bloc.dart';
import 'package:banking_app/features/auth/services/auth_repository.dart';
import 'package:banking_app/features/setting/bloc/setting_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt locator = GetIt.instance;

class AppLocators {
  static Future<void> setupLocators() async {
    locator.registerLazySingleton<BankingApiClient>(
      () => BankingApiClient(baseUrl: Env.endPoint),
    );

    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplement(client: Supabase.instance.client),
    );

    locator.registerFactory<SettingCubit>(
      () => SettingCubit(repo: locator<AuthRepository>()),
    );

    locator.registerFactory<AuthBloc>(
      () => AuthBloc(repo: locator<AuthRepository>()),
    );
  }
}
