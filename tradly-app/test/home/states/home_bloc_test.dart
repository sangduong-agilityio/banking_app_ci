import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/pages/home/states/home_bloc.dart';
import 'package:tradly_app/presentations/pages/home/states/home_event.dart';
import 'package:tradly_app/presentations/pages/home/states/home_state.dart';

import '../../helper/utils.dart';
import '../home_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final homeRepository = HomeRepositoryMocks();

  setUp(() {
    S.load(const Locale('en'));
  });

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
  });

  TABlocTest(
    description: 'HomeBloc Test',
    features: [
      TABlocTestFeature(
        description: 'HomeInitializeEvt',
        scenarios: [
          HomeBlocFetchedSuccessScenario(
            homeRepository: homeRepository,
          ),
          HomeBlocFetchedFailureScenario(
            homeRepository: homeRepository,
          ),
        ],
      ),
    ],
  ).test();
}

class HomeBlocFetchedSuccessScenario
    extends TABlocTestScenario<HomeBloc, HomeState> {
  HomeBlocFetchedSuccessScenario({
    required HomeRepositoryMocks homeRepository,
  }) : super(
          description: '''
          Scenario: Ensure that when the HomeBloc is initialized, the user details are fetched successfully
          Given: The HomeBloc is created with a mock repository.
          When: The _onFetched method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => homeRepository.fetchCategories())
                .thenAnswer((_) async => []);
            when(() => homeRepository.fetchStores())
                .thenAnswer((_) async => []);
            when(() => homeRepository.fetchNewProducts())
                .thenAnswer((_) async => []);
            when(() => homeRepository.fetchPopularProducts())
                .thenAnswer((_) async => []);
          },
          build: () => HomeBloc(repo: homeRepository),
          act: (bloc) => bloc.add(const HomeInitializeEvt(
            productId: 0,
          )),
          expect: () => [
            isA<HomeState>().having(
              (state) => state.status,
              'loading status',
              const HomeStatus.loading(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'success status',
              const HomeStatus.success(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'success status',
              const HomeStatus.success(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'success status',
              const HomeStatus.success(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'success status',
              const HomeStatus.success(),
            ),
          ],
        );
}

class HomeBlocFetchedFailureScenario
    extends TABlocTestScenario<HomeBloc, HomeState> {
  HomeBlocFetchedFailureScenario({
    required HomeRepositoryMocks homeRepository,
  }) : super(
          description: '''
          Scenario: Ensure that when the HomeBloc is initialized, the user details are fetched failure
          Given: The HomeBloc is created with a mock repository.
          When: The _onFetched method is called. 
          Then: The bloc should emit a HomeState with a status of failure.
          ''',
          setUp: () {
            when(() => homeRepository.fetchCategories())
                .thenThrow(Exception('Failed to fetch categories'));
            when(() => homeRepository.fetchStores())
                .thenThrow(Exception('Failed to fetch stores'));
            when(() => homeRepository.fetchNewProducts())
                .thenThrow(Exception('Failed to fetch new products'));
            when(() => homeRepository.fetchPopularProducts())
                .thenThrow(Exception('Failed to fetch popular products'));
          },
          build: () => HomeBloc(repo: homeRepository),
          act: (bloc) => bloc.add(const HomeInitializeEvt(
            productId: 0,
          )),
          expect: () => [
            isA<HomeState>().having(
              (state) => state.status,
              'loading status',
              const HomeStatus.loading(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'failure status',
              const HomeStatus.failure(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'loading status',
              const HomeStatus.loading(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'failure status',
              const HomeStatus.failure(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'loading status',
              const HomeStatus.loading(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'failure status',
              const HomeStatus.failure(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'loading status',
              const HomeStatus.loading(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'failure status',
              const HomeStatus.failure(),
            ),
            isA<HomeState>().having(
              (state) => state.status,
              'loading status',
              const HomeStatus.success(),
            ),
          ],
        );
}
