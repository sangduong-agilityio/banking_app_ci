import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/features/search/presentation/blocs/search_bloc.dart';
import 'package:get_it/get_it.dart';

import '../mocks/mock_search_bloc.dart';

void setupSearchServiceLocator(MockSearchBloc mockBloc) {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<SearchBloc>()) {
    getIt.unregister<SearchBloc>();
  }
  locator.registerFactory<SearchBloc>(() => mockBloc);
}

void cleanupSearchServiceLocator() {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<SearchBloc>()) {
    getIt.unregister<SearchBloc>();
  }
}
