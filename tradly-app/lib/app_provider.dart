import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/api/api_client.dart';
import 'package:tradly_app/env/env.dart';
import 'package:tradly_app/features/auth/repositories/auth_repo.dart';
import 'package:tradly_app/features/browse/repositories/browse_repo.dart';
import 'package:tradly_app/features/home/repositories/home_repo.dart';
import 'package:tradly_app/features/product_detail/repositories/product_repo.dart';
import 'package:tradly_app/features/store/repositories/store_repo.dart.dart';
import 'package:tradly_app/features/auth/states/sign_in_bloc.dart';
import 'package:tradly_app/features/auth/states/sign_up_bloc.dart';

class TAProvider extends StatelessWidget {
  const TAProvider({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TradlyApiClient>(
          create: (context) => TradlyApiClient(
            baseUrl: Env.endPoint,
          ),
        ),
        RepositoryProvider(
          create: (context) => SignInBloc(
            authRepository: AuthRepositoryImplement(
              Supabase.instance.client,
            ),
          ),
        ),
        RepositoryProvider(
          create: (context) => SignUpBloc(
            authRepository: AuthRepositoryImplement(
              Supabase.instance.client,
            ),
          ),
        ),
        RepositoryProvider<HomeRepository>(
          create: (context) => HomeRepositoryImpl(
            apiClient: TradlyApiClient(
              baseUrl: Env.endPoint,
            ),
          ),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            apiClient: TradlyApiClient(
              baseUrl: Env.endPoint,
            ),
          ),
        ),
        RepositoryProvider<StoreRepository>(
          create: (context) => StoreRepositoryImpl(
            apiClient: TradlyApiClient(
              baseUrl: Env.endPoint,
            ),
          ),
        ),
        RepositoryProvider<BrowseRepository>(
          create: (context) => BrowseRepositoryImpl(
            apiClient: TradlyApiClient(
              baseUrl: Env.endPoint,
            ),
          ),
        ),
      ],
      child: child,
    );
  }
}
