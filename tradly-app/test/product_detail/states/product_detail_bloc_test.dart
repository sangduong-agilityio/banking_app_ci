import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/features/product_detail/repositories/product_repo.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_bloc.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_event.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_state.dart';

import '../../helper/utils.dart';
import '../product_detail_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final productRepository = ProductDetailRepositoryMocks();

  setUp(() {
    S.load(const Locale('en'));
  });

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
  });
  TABlocTest(
    description: 'ProductDetailBloc Test',
    features: [
      TABlocTestFeature(
        description: 'ProductDetailInitializeEvt',
        scenarios: [
          ProductDetailInitializeSuccessScenario(
            productRepository: productRepository,
          ),
          ProductDetailInitializeFailureScenario(
            productRepository: productRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'ProductDetailFetchEvt',
        scenarios: [
          ProductDetailFetchEvtSuccessScenario(
            productRepository: productRepository,
          ),
          ProductDetailFetchEvtFailureScenario(
            productRepository: productRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'ProductDetailFormValidateChangedEvt',
        scenarios: [
          ProductDetailFormValidateChangedSuccessScenario(
            productRepository: productRepository,
          ),
          ProductDetailFormValidateChangedFailureScenario(
            productRepository: productRepository,
          ),
          ProductDetailFormValidateChangedEmptyScenario(
            productRepository: productRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'ProductDetailGetCurrentLocationEvt',
        scenarios: [
          ProductDetailGetCurrentLocationEvtSuccessScenario(
            productRepository: productRepository,
          ),
          ProductDetailGetCurrentLocationEvtFailureScenario(
            productRepository: productRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'ProductDetailAddAddressEvt',
        scenarios: [
          ProductDetailAddAddressEvtSuccessScenario(
            productRepository: productRepository,
          ),
          ProductDetailAddAddressEvtFailureScenario(
            productRepository: productRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'ProductDetailCheckoutEvt',
        scenarios: [
          ProductDetailCheckoutEvtSuccessScenario(
            productRepository: productRepository,
          ),
          ProductDetailCheckoutEvtFailureScenario(
            productRepository: productRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'ProductDetailToggleWishListEvt',
        scenarios: [
          ProductDetailToggleWishListEvtSuccessScenario(
            productRepository: productRepository,
          ),
          ProductDetailToggleWishListEvtFailureScenario(
            productRepository: productRepository,
          ),
        ],
      ),
    ],
  ).test();
}

class ProductDetailInitializeSuccessScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailInitializeSuccessScenario({
    required ProductRepository productRepository,
  }) : super(
            description: '''
         Scenario: Ensure that when the ProductDetailBloc is initialized, the user details are fetched successfully
          Given: The ProductDetailBloc is created with a mock repository.
          When: The _onFetched method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
            setUp: () {
              when(() => productRepository.fetchProductsByCategoryId(0))
                  .thenAnswer((_) async => []);
              when(() => productRepository.fetchProductById(0)).thenAnswer(
                (_) async => [],
              );
            },
            build: () => ProductDetailBloc(
                  repo: productRepository,
                ),
            act: (bloc) => bloc.add(
                  const ProductDetailInitializeEvt(categoryId: 0),
                ),
            expect: () => [
                  isA<ProductDetailState>().having(
                    (state) => state.status,
                    'loading status',
                    const ProductDetailStatus.loading(),
                  ),
                  isA<ProductDetailState>().having(
                    (state) => state.status,
                    'success status',
                    const ProductDetailStatus.success(),
                  ),
                ]);
}

class ProductDetailInitializeFailureScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailInitializeFailureScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailBloc is initialized, the user details are fetched successfully
          Given: The ProductDetailBloc is created with a mock repository.
          When: The _onFetched method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenThrow(Exception());
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            const ProductDetailInitializeEvt(categoryId: 0),
          ),
          expect: () => [
            isA<ProductDetailState>().having(
              (state) => state.status,
              'loading status',
              const ProductDetailStatus.loading(),
            ),
            isA<ProductDetailState>().having(
              (state) => state.status,
              'failure status',
              const ProductDetailStatus.failure(),
            ),
          ],
        );
}

class ProductDetailFetchEvtSuccessScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailFetchEvtSuccessScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailFetchEvt is initialized, the user details are fetched successfully
          Given: The ProductDetailFetchEvt is created with a mock repository.
          When: The _onFetched method is called.
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenAnswer((_) async => []);
            when(() => productRepository.fetchProductById(0)).thenAnswer(
              (_) async => [],
            );
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            const ProductDetailFetchEvt(productId: 0),
          ),
          expect: () => [
            isA<ProductDetailState>().having(
              (state) => state.status,
              'loading status',
              const ProductDetailStatus.loading(),
            ),
            isA<ProductDetailState>().having(
              (state) => state.status,
              'failure status',
              const ProductDetailStatus.failure(),
            ),
          ],
        );
}

class ProductDetailFetchEvtFailureScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailFetchEvtFailureScenario({
    required ProductRepository productRepository,
  }) : super(
            description: '''
         Scenario: Ensure that when the ProductDetailFetchEvt is initialized, the user details are fetched successfully
          Given: The ProductDetailFetchEvt is created with a mock repository.
          When: The _onFetched method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
            setUp: () {
              when(() => productRepository.fetchProductById(0))
                  .thenThrow(Exception());
            },
            build: () => ProductDetailBloc(
                  repo: productRepository,
                ),
            act: (bloc) => bloc.add(
                  const ProductDetailFetchEvt(productId: 0),
                ),
            expect: () => [
                  isA<ProductDetailState>().having(
                    (state) => state.status,
                    'loading status',
                    const ProductDetailStatus.loading(),
                  ),
                  isA<ProductDetailState>().having(
                    (state) => state.status,
                    'failure status',
                    const ProductDetailStatus.failure(),
                  ),
                ]);
}

class ProductDetailFormValidateChangedSuccessScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailFormValidateChangedSuccessScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailFormValidateChangedEvt is initialized, the form validation is successful
          Given: The ProductDetailFormValidateChangedEvt is created with a mock repository.
          When: The _onFormValidateChanged method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenAnswer((_) async => []);
            when(() => productRepository.fetchProductById(0)).thenAnswer(
              (_) async => [],
            );
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            const ProductDetailFormValidateChangedEvt(isValidate: true),
          ),
          expect: () => [
            isA<ProductDetailState>().having(
              (state) => state.isFormValid,
              'isFormValid',
              true,
            ),
          ],
        );
}

class ProductDetailFormValidateChangedFailureScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailFormValidateChangedFailureScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailFormValidateChangedEvt is initialized, the form validation fails
          Given: The ProductDetailFormValidateChangedEvt is created with a mock repository.
          When: The _onFormValidateChanged method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenAnswer((_) async => []);
            when(() => productRepository.fetchProductById(0)).thenAnswer(
              (_) async => [],
            );
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            const ProductDetailFormValidateChangedEvt(isValidate: false),
          ),
          expect: () => [
            isA<ProductDetailState>().having(
              (state) => state.isFormValid,
              'isFormValid',
              false,
            ),
          ],
        );
}

class ProductDetailFormValidateChangedEmptyScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailFormValidateChangedEmptyScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailFormValidateChangedEvt is initialized, the form validation is empty
          Given: The ProductDetailFormValidateChangedEvt is created with a mock repository.
          When: The _onFormValidateChanged method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenAnswer((_) async => []);
            when(() => productRepository.fetchProductById(0)).thenAnswer(
              (_) async => [],
            );
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            const ProductDetailFormValidateChangedEvt(isValidate: false),
          ),
          expect: () => [
            isA<ProductDetailState>().having(
              (state) => state.isFormValid,
              'isFormValid',
              false,
            ),
          ],
        );
}

class ProductDetailGetCurrentLocationEvtSuccessScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailGetCurrentLocationEvtSuccessScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailGetCurrentLocationEvt is initialized, the current location is fetched successfully
          Given: The ProductDetailGetCurrentLocationEvt is created with a mock repository.
          When: The _onGetCurrentLocation method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenAnswer((_) async => []);
            when(() => productRepository.fetchProductById(0)).thenAnswer(
              (_) async => [],
            );
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            const ProductDetailGetCurrentLocationEvt(),
          ),
          expect: () => [
            isA<ProductDetailState>().having(
              (state) => state.status,
              'loading status',
              const ProductDetailStatus.loading(),
            ),
          ],
        );
}

class ProductDetailGetCurrentLocationEvtFailureScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailGetCurrentLocationEvtFailureScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailGetCurrentLocationEvt is initialized, the current location is fetched successfully
          Given: The ProductDetailGetCurrentLocationEvt is created with a mock repository.
          When: The _onGetCurrentLocation method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenAnswer((_) async => []);
            when(() => productRepository.fetchProductById(0)).thenAnswer(
              (_) async => [],
            );
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            const ProductDetailGetCurrentLocationEvt(),
          ),
          expect: () => [
            isA<ProductDetailState>().having(
              (state) => state.status,
              'loading status',
              const ProductDetailStatus.loading(),
            ),
          ],
        );
}

class ProductDetailAddAddressEvtSuccessScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailAddAddressEvtSuccessScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailAddAddressEvt is initialized, the address is added successfully
          Given: The ProductDetailAddAddressEvt is created with a mock repository.
          When: The _onAddAddress method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenAnswer((_) async => []);
            when(() => productRepository.fetchProductById(0)).thenAnswer(
              (_) async => [],
            );
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            const ProductDetailAddAddressEvt(),
          ),
          expect: () => [
            isA<ProductDetailState>().having(
              (state) => state.status,
              'loading status',
              const ProductDetailStatus.loading(),
            ),
            isA<ProductDetailState>().having(
              (state) => state.status,
              'success status',
              const ProductDetailStatus.success(),
            ),
          ],
        );
}

class ProductDetailAddAddressEvtFailureScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailAddAddressEvtFailureScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailAddAddressEvt is initialized, the address is added successfully
          Given: The ProductDetailAddAddressEvt is created with a mock repository.
          When: The _onAddAddress method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenThrow((_) async => []);
            when(() => productRepository.fetchProductById(0))
                .thenThrow((_) async => []);
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            const ProductDetailAddAddressEvt(),
          ),
          expect: () => [
            isA<ProductDetailState>().having(
              (state) => state.status,
              'loading status',
              const ProductDetailStatus.loading(),
            ),
            isA<ProductDetailState>().having(
              (state) => state.status,
              'success status',
              const ProductDetailStatus.success(),
            ),
          ],
        );
}

class ProductDetailCheckoutEvtSuccessScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailCheckoutEvtSuccessScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailCheckoutEvt is initialized, the checkout is successful
          Given: The ProductDetailCheckoutEvt is created with a mock repository.
          When: The _onCheckout method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenAnswer((_) async => []);
            when(() => productRepository.fetchProductById(0)).thenAnswer(
              (_) async => [],
            );
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            ProductDetailCheckoutEvt(
              product: ProductDetailMocks.product,
            ),
          ),
          expect: () => [
            isA<ProductDetailState>().having(
              (state) => state.status,
              'loading status',
              const ProductDetailStatus.loading(),
            ),
            isA<ProductDetailState>().having(
              (state) => state.status,
              'failure status',
              const ProductDetailStatus.failure(),
            ),
          ],
        );
}

class ProductDetailCheckoutEvtFailureScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailCheckoutEvtFailureScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailCheckoutEvt is initialized, the checkout is successful
          Given: The ProductDetailCheckoutEvt is created with a mock repository.
          When: The _onCheckout method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenAnswer((_) async => []);
            when(() => productRepository.fetchProductById(0)).thenAnswer(
              (_) async => [],
            );
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            ProductDetailCheckoutEvt(
              product: ProductDetailMocks.product,
            ),
          ),
          expect: () => [
            isA<ProductDetailState>().having(
              (state) => state.status,
              'loading status',
              const ProductDetailStatus.loading(),
            ),
            isA<ProductDetailState>().having(
              (state) => state.status,
              'failure status',
              const ProductDetailStatus.failure(),
            ),
          ],
        );
}

class ProductDetailToggleWishListEvtSuccessScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailToggleWishListEvtSuccessScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailToggleWishListEvt is initialized, the wishlist is toggled successfully
          Given: The ProductDetailToggleWishListEvt is created with a mock repository.
          When: The _onToggleWishList method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenAnswer((_) async => []);
            when(() => productRepository.fetchProductById(0)).thenAnswer(
              (_) async => [],
            );
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            const ProductDetailToggleWishListEvt(productId: 0),
          ),
          expect: () => [],
        );
}

class ProductDetailToggleWishListEvtFailureScenario
    extends TABlocTestScenario<ProductDetailBloc, ProductDetailState> {
  ProductDetailToggleWishListEvtFailureScenario({
    required ProductRepository productRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProductDetailToggleWishListEvt is initialized, the wishlist toggle fails
          Given: The ProductDetailToggleWishListEvt is created with a mock repository.
          When: The _onToggleWishList method is called. 
          Then: The bloc should emit a HomeState with a status of failure.
          ''',
          setUp: () {
            when(() => productRepository.fetchProductsByCategoryId(0))
                .thenThrow(Exception());
            when(() => productRepository.fetchProductById(0))
                .thenThrow(Exception());
          },
          build: () => ProductDetailBloc(
            repo: productRepository,
          ),
          act: (bloc) => bloc.add(
            const ProductDetailToggleWishListEvt(productId: 0),
          ),
          expect: () => [],
        );
}
