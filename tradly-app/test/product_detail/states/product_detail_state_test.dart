import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_state.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'ProductDetailState Test',
    features: [
      TAUTFeature(
        description: 'ProductDetailState',
        scenarios: [
          ProductDetailStatePropsScenario(),
          ProductDetailStateEqualityScenario(),
          ProductDetailStateCopyWithScenario(),
          ProductDetailStateDefaultValuesScenario(),
          ProductDetailStateToStringScenario(),
          ProductDetailStateCopyWithStatusScenario(),
        ],
      ),
    ],
  ).test();
}

class ProductDetailStatePropsScenario
    extends TAUTScenario<ProductDetailState, ProductDetailState> {
  ProductDetailStatePropsScenario()
      : super(
          description: '''
           Scenario: Test ProductDetailState PropsScenario
            Given ProductDetailState instance
            When accessing props
            Then it should return the correct values
          ''',
          when: () async {
            return ProductDetailState(
              status: const ProductDetailStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const ProductDetailStatus.success(),
          ),
          expect: (ProductDetailState result) {
            expect(
              result.status == const ProductDetailStatus.success(),
              isTrue,
            );
          },
        );
}

class ProductDetailStateEqualityScenario
    extends TAUTScenario<ProductDetailState, ProductDetailState> {
  ProductDetailStateEqualityScenario()
      : super(
          description: '''
           Scenario: Test ProductDetailState Equality
            Given two ProductDetailState instances with the same properties
            When checking for equality
            Then it should return true
          ''',
          when: () async {
            return ProductDetailState(
              status: const ProductDetailStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (result) => result,
          expect: (ProductDetailState result) {
            expect(result == result, isTrue);
          },
        );
}

class ProductDetailStateCopyWithScenario
    extends TAUTScenario<ProductDetailState, ProductDetailState> {
  ProductDetailStateCopyWithScenario()
      : super(
          description: '''
           Scenario: Test ProductDetailState CopyWith
            Given a ProductDetailState instance
            When using copyWith to modify properties
            Then it should return a new instance with updated properties
          ''',
          when: () async {
            return ProductDetailState(
              status: const ProductDetailStatus.initial(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const ProductDetailStatus.success(),
            errorMessage: 'new error',
          ),
          expect: (ProductDetailState result) {
            expect(result.status, const ProductDetailStatus.success());
            expect(result.errorMessage, 'new error');
          },
        );
}

class ProductDetailStateDefaultValuesScenario
    extends TAUTScenario<ProductDetailState, ProductDetailState> {
  ProductDetailStateDefaultValuesScenario()
      : super(
          description: '''
           Scenario: Test ProductDetailState Default Values
            Given a ProductDetailState instance with default values
            When accessing properties
            Then it should return the default values
          ''',
          when: () async {
            return const ProductDetailState();
          },
          act: (state) => state,
          expect: (ProductDetailState result) {
            expect(result.status, const ProductDetailStatus.initial());
            expect(result.errorMessage, isNull);
            expect(result.products, isNull);
            expect(result.product, isNull);
            expect(result.hasAddress, isFalse);
            expect(result.isFormValid, isFalse);
          },
        );
}

class ProductDetailStateToStringScenario
    extends TAUTScenario<ProductDetailState, String> {
  ProductDetailStateToStringScenario()
      : super(
          description: '''
           Scenario: Test ProductDetailState toString method
            Given a ProductDetailState instance
            When calling toString
            Then it should return a string representation of the state
          ''',
          when: () async {
            return ProductDetailState(
              status: const ProductDetailStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.toString(),
          expect: (String result) {
            expect(result,
                'ProductDetailState(ProductDetailStatus.success(), error, null, null, false, false)');
          },
        );
}

class ProductDetailStateCopyWithStatusScenario
    extends TAUTScenario<ProductDetailState, ProductDetailState> {
  ProductDetailStateCopyWithStatusScenario()
      : super(
          description: '''
           Scenario: Test ProductDetailState copyWith with status
            Given a ProductDetailState instance
            When using copyWith to modify status
            Then it should return a new instance with updated status
          ''',
          when: () async {
            return ProductDetailState(
              status: const ProductDetailStatus.initial(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const ProductDetailStatus.loading(),
          ),
          expect: (ProductDetailState result) {
            expect(result.status, const ProductDetailStatus.loading());
          },
        );
}
