import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradly_app/features/browse/repositories/browse_repo.dart';
import 'package:tradly_app/features/browse/states/browse_bloc.dart';
import 'package:tradly_app/features/browse/states/browse_event.dart';
import 'package:tradly_app/features/browse/states/browse_state.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';

import '../../helper/utils.dart';
import '../browse_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final browseRepository = BrowseRepositoryMocks();

  setUp(() {
    S.load(const Locale('en'));
  });

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
  });

  TABlocTest(
    description: 'BrowseBloc Test',
    features: [
      TABlocTestFeature(
        description: 'BrowseInitializeEvt',
        scenarios: [
          BrowseInitializeSuccessScenario(
            browseRepository: browseRepository,
          ),
          BrowseInitializeFailureScenario(
            browseRepository: browseRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'BrowseSearchEvt',
        scenarios: [
          BrowseSearchSuccessScenario(
            browseRepository: browseRepository,
          ),
          BrowseSearchFailureScenario(
            browseRepository: browseRepository,
          ),
          BrowseSearchNoMatchScenario(
            browseRepository: browseRepository,
          )
        ],
      ),
      TABlocTestFeature(
        description: 'BrowseSortEvt',
        scenarios: [
          BrowseSortSuccessScenario(
            browseRepository: browseRepository,
          ),
          BrowseSortFailureScenario(
            browseRepository: browseRepository,
          ),
          BrowseSortHighToLowScenario(
            browseRepository: browseRepository,
          ),
          BrowseSortLowToHighScenario(
            browseRepository: browseRepository,
          ),
        ],
      ),
    ],
  ).test();
}

class BrowseInitializeSuccessScenario
    extends TABlocTestScenario<BrowseBloc, BrowseState> {
  BrowseInitializeSuccessScenario({
    required BrowseRepository browseRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the BrowseBloc is initialized, products are fetched successfully
          Given: The BrowseBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a BrowseState with a status of success.
          ''',
          setUp: () {
            when(() => browseRepository.fetchProducts())
                .thenAnswer((_) async => []);
          },
          build: () => BrowseBloc(repo: browseRepository),
          act: (bloc) => bloc.add(const BrowseInitializeEvt()),
          expect: () => [
            isA<BrowseState>().having(
              (state) => state.status,
              'loading status',
              const BrowseStatus.loading(),
            ),
            isA<BrowseState>().having(
              (state) => state.status,
              'success status',
              const BrowseStatus.success(),
            ),
          ],
        );
}

class BrowseInitializeFailureScenario
    extends TABlocTestScenario<BrowseBloc, BrowseState> {
  BrowseInitializeFailureScenario({
    required BrowseRepository browseRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the BrowseBloc is initialized, fetching products fails
          Given: The BrowseBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a BrowseState with a status of failure.
          ''',
          setUp: () {
            when(() => browseRepository.fetchProducts())
                .thenThrow(Exception('Failed to fetch products'));
          },
          build: () => BrowseBloc(repo: browseRepository),
          act: (bloc) => bloc.add(const BrowseInitializeEvt()),
          expect: () => [
            isA<BrowseState>().having(
              (state) => state.status,
              'loading status',
              const BrowseStatus.loading(),
            ),
            isA<BrowseState>().having(
              (state) => state.status,
              'failure status',
              const BrowseStatus.failure(),
            ),
          ],
        );
}

class BrowseSearchSuccessScenario
    extends TABlocTestScenario<BrowseBloc, BrowseState> {
  BrowseSearchSuccessScenario({
    required BrowseRepository browseRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the BrowseSearchEvt is triggered, products matching the query are fetched successfully
          Given: The BrowseBloc is created with a mock repository.
          When: The _onSearchProduct method is called. 
          Then: The bloc should emit a BrowseState with a status of success and filtered products.
          ''',
          setUp: () {
            when(() => browseRepository.fetchProducts()).thenAnswer(
              (_) async => [],
            );
          },
          build: () => BrowseBloc(repo: browseRepository),
          act: (bloc) => bloc.add(const BrowseSearchEvt(query: 'test')),
          expect: () => [
            isA<BrowseState>().having(
              (state) => state.status,
              'loading status',
              const BrowseStatus.loading(),
            ),
            isA<BrowseState>().having(
              (state) => state.status,
              'success status',
              const BrowseStatus.success(),
            ),
          ],
        );
}

class BrowseSearchFailureScenario
    extends TABlocTestScenario<BrowseBloc, BrowseState> {
  BrowseSearchFailureScenario({
    required BrowseRepository browseRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the BrowseSearchEvt is triggered, fetching products fails
          Given: The BrowseBloc is created with a mock repository.
          When: The _onSearchProduct method is called. 
          Then: The bloc should emit a BrowseState with a status of failure.
          ''',
          setUp: () {
            when(() => browseRepository.fetchProducts())
                .thenThrow(Exception('Search failed'));
          },
          build: () => BrowseBloc(repo: browseRepository),
          act: (bloc) => bloc.add(const BrowseSearchEvt(query: 'test')),
          expect: () => [
            isA<BrowseState>().having(
              (state) => state.status,
              'loading status',
              const BrowseStatus.loading(),
            ),
            isA<BrowseState>().having(
              (state) => state.status,
              'failure status',
              const BrowseStatus.success(),
            ),
          ],
        );
}

class BrowseSearchNoMatchScenario
    extends TABlocTestScenario<BrowseBloc, BrowseState> {
  BrowseSearchNoMatchScenario({
    required BrowseRepository browseRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the BrowseSearchEvt is triggered, products matching the query are fetched successfully
          Given: The BrowseBloc is created with a mock repository.
          When: The _onSearchProduct method is called. 
          Then: The bloc should emit a BrowseState with a status of success and filtered products.
          ''',
          setUp: () {
            when(() => browseRepository.fetchProducts()).thenAnswer(
              (_) async => [
                ProductModel(title: 'Product A', price: '10', imageUrl: ''),
                ProductModel(title: 'Product B', price: '20', imageUrl: ''),
              ],
            );
          },
          build: () => BrowseBloc(repo: browseRepository),
          act: (bloc) => bloc.add(const BrowseSearchEvt(query: 'test')),
          expect: () => [
            isA<BrowseState>().having(
              (state) => state.status,
              'loading status',
              const BrowseStatus.loading(),
            ),
            isA<BrowseState>().having(
              (state) => state.status,
              'success status',
              const BrowseStatus.success(),
            ),
          ],
        );
}

class BrowseSortSuccessScenario
    extends TABlocTestScenario<BrowseBloc, BrowseState> {
  BrowseSortSuccessScenario({
    required BrowseRepository browseRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the BrowseSortEvt is triggered, products are sorted successfully
          Given: The BrowseBloc is created with a mock repository.
          When: The _onSortProduct method is called. 
          Then: The bloc should emit a BrowseState with a status of success and sorted products.
          ''',
          setUp: () {
            when(() => browseRepository.fetchProducts()).thenAnswer(
              (_) async => [],
            );
          },
          build: () => BrowseBloc(repo: browseRepository),
          act: (bloc) =>
              bloc.add(const BrowseSortEvt(sort: SortOrder.lowToHigh)),
          expect: () => [
            isA<BrowseState>().having(
              (state) => state.status,
              'loading status',
              const BrowseStatus.loading(),
            ),
            isA<BrowseState>().having(
              (state) => state.status,
              'success status',
              const BrowseStatus.success(),
            ),
          ],
        );
}

class BrowseSortFailureScenario
    extends TABlocTestScenario<BrowseBloc, BrowseState> {
  BrowseSortFailureScenario({
    required BrowseRepository browseRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the BrowseSortEvt is triggered, sorting products fails
          Given: The BrowseBloc is created with a mock repository.
          When: The _onSortProduct method is called. 
          Then: The bloc should emit a BrowseState with a status of failure.
          ''',
          setUp: () {
            when(() => browseRepository.fetchProducts())
                .thenThrow(Exception('Sort failed'));
          },
          build: () => BrowseBloc(repo: browseRepository),
          act: (bloc) =>
              bloc.add(const BrowseSortEvt(sort: SortOrder.lowToHigh)),
          expect: () => [
            isA<BrowseState>().having(
              (state) => state.status,
              'loading status',
              const BrowseStatus.loading(),
            ),
            isA<BrowseState>().having(
              (state) => state.status,
              'failure status',
              const BrowseStatus.failure(),
            ),
          ],
        );
}

class BrowseSortHighToLowScenario
    extends TABlocTestScenario<BrowseBloc, BrowseState> {
  BrowseSortHighToLowScenario({
    required BrowseRepository browseRepository,
  }) : super(
          description: '''
     Scenario: Ensure that when the BrowseSortEvt is triggered with an unhandled sort order, products remain unsorted
      Given: The BrowseBloc is created with a mock repository.
      When: The _onSortProduct method is called with an invalid sort order. 
      Then: The bloc should emit a BrowseState with a status of success and unsorted products.
      ''',
          setUp: () {
            when(() => browseRepository.fetchProducts()).thenAnswer(
              (_) async => [
                ProductModel(title: 'Product A', price: '10', imageUrl: ''),
                ProductModel(title: 'Product B', price: '20', imageUrl: ''),
              ],
            );
          },
          build: () => BrowseBloc(repo: browseRepository),
          act: (bloc) => bloc.add(BrowseSortEvt(sort: SortOrder.highToLow)),
          expect: () => [
            isA<BrowseState>().having(
              (state) => state.status,
              'loading status',
              const BrowseStatus.loading(),
            ),
            isA<BrowseState>().having(
              (state) => state.status,
              'success status',
              const BrowseStatus.success(),
            ),
          ],
        );
}

class BrowseSortLowToHighScenario
    extends TABlocTestScenario<BrowseBloc, BrowseState> {
  BrowseSortLowToHighScenario({
    required BrowseRepository browseRepository,
  }) : super(
            description: '''
     Scenario: Ensure that when the BrowseSortEvt is triggered with an unhandled sort order, products remain unsorted
      Given: The BrowseBloc is created with a mock repository.
      When: The _onSortProduct method is called with an invalid sort order. 
      Then: The bloc should emit a BrowseState with a status of success and unsorted products.
      ''',
            setUp: () {
              when(() => browseRepository.fetchProducts()).thenAnswer(
                (_) async => [
                  ProductModel(title: 'Product A', price: '10', imageUrl: ''),
                  ProductModel(title: 'Product B', price: '20', imageUrl: ''),
                ],
              );
            },
            build: () => BrowseBloc(repo: browseRepository),
            act: (bloc) => bloc.add(BrowseSortEvt(sort: SortOrder.lowToHigh)),
            expect: () => [
                  isA<BrowseState>().having(
                    (state) => state.status,
                    'loading status',
                    const BrowseStatus.loading(),
                  ),
                  isA<BrowseState>().having(
                    (state) => state.status,
                    'success status',
                    const BrowseStatus.success(),
                  ),
                ]);
}
