import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/api/api_client.dart';
import 'package:tradly_app/env/env.dart';
import 'package:tradly_app/features/auth/repositories/auth_repo.dart';
import 'package:tradly_app/features/browse/repositories/browse_repo.dart';
import 'package:tradly_app/features/home/repositories/home_repo.dart';
import 'package:tradly_app/features/product_detail/repositories/product_repo.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_bloc.dart';
import 'package:tradly_app/features/store/repositories/store_repo.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_cubit.dart';

class TAProvider extends StatelessWidget {
  const TAProvider({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final apiClient = TradlyApiClient(baseUrl: Env.endPoint);
    final authRepository = AuthRepositoryImplement(Supabase.instance.client);
    final homeRepository = HomeRepositoryImpl(apiClient: apiClient);
    final productRepository = ProductRepositoryImpl(apiClient: apiClient);
    final storeRepository = StoreRepositoryImpl(apiClient: apiClient);
    final browseRepository = BrowseRepositoryImpl(apiClient: apiClient);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TradlyApiClient>(
          create: (context) => apiClient,
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => authRepository,
        ),
        RepositoryProvider<HomeRepository>(
          create: (context) => homeRepository,
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => productRepository,
        ),
        RepositoryProvider<StoreRepository>(
          create: (context) => storeRepository,
        ),
        RepositoryProvider<BrowseRepository>(
          create: (context) => browseRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ProductDetailBloc(
              repo: productRepository,
            ),
          ),
          BlocProvider(
            create: (_) => WishListCubit(),
          ),
        ],
        child: child,
      ),
    );
  }
}
