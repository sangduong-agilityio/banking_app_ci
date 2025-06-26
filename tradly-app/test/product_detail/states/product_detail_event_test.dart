import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_event.dart';

import '../../helper/utils.dart';
import '../product_detail_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'ProductDetailEvt Test',
    features: [
      TAUTFeature(
        description: 'ProductDetailEvt',
        scenarios: [
          ProductDetailEvtPropsScenario(),
        ],
      ),
      TAUTFeature(
        description: 'ProductDetailInitializeEvt',
        scenarios: [
          ProductDetailInitializeEvtPropsScenario(),
          ProductDetailInitializeEvtWithToStringScenario(),
          ProductDetailInitializeEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'ProductDetailFetchEvt',
        scenarios: [
          ProductDetailFetchEvtPropsScenario(),
          ProductDetailFetchEvtWithToStringScenario(),
          ProductDetailFetchEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'ProductDetailGetCurrentLocationEvt',
        scenarios: [
          ProductDetailGetCurrentLocationEvtPropsScenario(),
          ProductDetailGetCurrentLocationEvtWithToStringScenario(),
          ProductDetailGetCurrentLocationEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'ProductDetailAddAddressEvt',
        scenarios: [
          ProductDetailAddAddressEvtPropsScenario(),
          ProductDetailAddAddressEvtWithToStringScenario(),
          ProductDetailAddAddressEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'ProductDetailFormValidateChangedEvt',
        scenarios: [
          ProductDetailFormValidateChangedEvtPropsScenario(),
          ProductDetailFormValidateChangedEvtWithToStringScenario(),
          ProductDetailFormValidateChangedEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'ProductDetailCheckoutEvt',
        scenarios: [
          ProductDetailCheckoutEvtPropsScenario(),
          ProductDetailCheckoutEvtWithToStringScenario(),
          ProductDetailCheckoutEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'ProductDetailToggleWishListEvt',
        scenarios: [
          ProductDetailToggleWishListEvtPropsScenario(),
        ],
      ),
    ],
  ).test();
}

class ProductDetailEvtPropsScenario
    extends TAUTScenario<ProductDetailEvt, List<Object?>> {
  ProductDetailEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailEvt Props
            Given ProductDetailEvt event
            When creating a ProductDetailEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return ProductDetailEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}

class ProductDetailInitializeEvtPropsScenario
    extends TAUTScenario<ProductDetailInitializeEvt, List<Object?>> {
  ProductDetailInitializeEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailInitializeEvt Props
            Given ProductDetailInitializeEvt event
            When creating a ProductDetailInitializeEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return ProductDetailInitializeEvt(
              categoryId: 0,
            );
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [0]);
          },
        );
}

class ProductDetailInitializeEvtWithToStringScenario
    extends TAUTScenario<ProductDetailInitializeEvt, String> {
  ProductDetailInitializeEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailInitializeEvt toString
            Given ProductDetailInitializeEvt event
            When creating a ProductDetailInitializeEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return ProductDetailInitializeEvt(
              categoryId: 0,
            );
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class ProductDetailInitializeEvtEqualityScenario
    extends TAUTScenario<ProductDetailInitializeEvt, bool> {
  ProductDetailInitializeEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test equality of ProductDetailInitializeEvt
          Given two ProductDetailInitializeEvt event
          When comparing them
          Then they should be equal
          ''',
          when: () async {
            return ProductDetailInitializeEvt(
              categoryId: 0,
            );
          },
          act: (event) =>
              event ==
              const ProductDetailInitializeEvt(
                categoryId: 0,
              ),
          expect: (bool result) {
            expect(result, isTrue);
          },
        );
}

class ProductDetailFetchEvtPropsScenario
    extends TAUTScenario<ProductDetailFetchEvt, List<Object?>> {
  ProductDetailFetchEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailFetchEvt Props
            Given ProductDetailFetchEvt event
            When creating a ProductDetailFetchEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return ProductDetailFetchEvt(
              productId: 0,
            );
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [0]);
          },
        );
}

class ProductDetailFetchEvtWithToStringScenario
    extends TAUTScenario<ProductDetailFetchEvt, String> {
  ProductDetailFetchEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailFetchEvt toString
            Given ProductDetailFetchEvt event
            When creating a ProductDetailFetchEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return ProductDetailFetchEvt(
              productId: 0,
            );
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class ProductDetailFetchEvtEqualityScenario
    extends TAUTScenario<ProductDetailFetchEvt, bool> {
  ProductDetailFetchEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test equality of ProductDetailFetchEvt
          Given two ProductDetailFetchEvt event
          When comparing them
          Then they should be equal
          ''',
          when: () async {
            return ProductDetailFetchEvt(
              productId: 0,
            );
          },
          act: (event) =>
              event ==
              const ProductDetailFetchEvt(
                productId: 0,
              ),
          expect: (bool result) {
            expect(result, isTrue);
          },
        );
}

class ProductDetailGetCurrentLocationEvtPropsScenario
    extends TAUTScenario<ProductDetailGetCurrentLocationEvt, List<Object?>> {
  ProductDetailGetCurrentLocationEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailGetCurrentLocationEvt Props
            Given ProductDetailGetCurrentLocationEvt event
            When creating a ProductDetailGetCurrentLocationEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return ProductDetailGetCurrentLocationEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, []);
          },
        );
}

class ProductDetailGetCurrentLocationEvtWithToStringScenario
    extends TAUTScenario<ProductDetailGetCurrentLocationEvt, String> {
  ProductDetailGetCurrentLocationEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailGetCurrentLocationEvt toString
            Given ProductDetailGetCurrentLocationEvt event
            When creating a ProductDetailGetCurrentLocationEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return ProductDetailGetCurrentLocationEvt();
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class ProductDetailGetCurrentLocationEvtEqualityScenario
    extends TAUTScenario<ProductDetailGetCurrentLocationEvt, bool> {
  ProductDetailGetCurrentLocationEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test equality of ProductDetailGetCurrentLocationEvt
          Given two ProductDetailGetCurrentLocationEvt event
          When comparing them
          Then they should be equal
          ''',
          when: () async {
            return ProductDetailGetCurrentLocationEvt();
          },
          act: (event) => event == const ProductDetailGetCurrentLocationEvt(),
          expect: (bool result) {
            expect(result, isTrue);
          },
        );
}

class ProductDetailAddAddressEvtPropsScenario
    extends TAUTScenario<ProductDetailAddAddressEvt, List<Object?>> {
  ProductDetailAddAddressEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailAddAddressEvt Props
            Given ProductDetailAddAddressEvt event
            When creating a ProductDetailAddAddressEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return ProductDetailAddAddressEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, []);
          },
        );
}

class ProductDetailAddAddressEvtWithToStringScenario
    extends TAUTScenario<ProductDetailAddAddressEvt, String> {
  ProductDetailAddAddressEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailAddAddressEvt toString
            Given ProductDetailAddAddressEvt event
            When creating a ProductDetailAddAddressEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return ProductDetailAddAddressEvt();
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class ProductDetailAddAddressEvtEqualityScenario
    extends TAUTScenario<ProductDetailAddAddressEvt, bool> {
  ProductDetailAddAddressEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test equality of ProductDetailAddAddressEvt
          Given two ProductDetailAddAddressEvt event
          When comparing them
          Then they should be equal
          ''',
          when: () async {
            return ProductDetailAddAddressEvt();
          },
          act: (event) => event == const ProductDetailAddAddressEvt(),
          expect: (bool result) {
            expect(result, isTrue);
          },
        );
}

class ProductDetailFormValidateChangedEvtPropsScenario
    extends TAUTScenario<ProductDetailFormValidateChangedEvt, List<Object?>> {
  ProductDetailFormValidateChangedEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailFormValidateChangedEvt Props
            Given ProductDetailFormValidateChangedEvt event
            When creating a ProductDetailFormValidateChangedEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return ProductDetailFormValidateChangedEvt(
              isValidate: true,
            );
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [true]);
          },
        );
}

class ProductDetailFormValidateChangedEvtWithToStringScenario
    extends TAUTScenario<ProductDetailFormValidateChangedEvt, String> {
  ProductDetailFormValidateChangedEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailFormValidateChangedEvt toString
            Given ProductDetailFormValidateChangedEvt event
            When creating a ProductDetailFormValidateChangedEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return ProductDetailFormValidateChangedEvt(
              isValidate: true,
            );
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class ProductDetailFormValidateChangedEvtEqualityScenario
    extends TAUTScenario<ProductDetailFormValidateChangedEvt, bool> {
  ProductDetailFormValidateChangedEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test equality of ProductDetailFormValidateChangedEvt
          Given two ProductDetailFormValidateChangedEvt event
          When comparing them
          Then they should be equal
          ''',
          when: () async {
            return ProductDetailFormValidateChangedEvt(
              isValidate: true,
            );
          },
          act: (event) =>
              event ==
              const ProductDetailFormValidateChangedEvt(
                isValidate: true,
              ),
          expect: (bool result) {
            expect(result, isTrue);
          },
        );
}

class ProductDetailCheckoutEvtPropsScenario
    extends TAUTScenario<ProductDetailCheckoutEvt, List<Object?>> {
  ProductDetailCheckoutEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailCheckoutEvt Props
            Given ProductDetailCheckoutEvt event
            When creating a ProductDetailCheckoutEvt event and accessing props
            Then the props should not be empty
            ''',
          when: () async {
            return ProductDetailCheckoutEvt(
              product: ProductDetailMocks.product,
            );
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [
              ProductDetailMocks.product,
            ]);
          },
        );
}

class ProductDetailCheckoutEvtWithToStringScenario
    extends TAUTScenario<ProductDetailCheckoutEvt, String> {
  ProductDetailCheckoutEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailCheckoutEvt toString
            Given ProductDetailCheckoutEvt event
            When creating a ProductDetailCheckoutEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return ProductDetailCheckoutEvt(
              product: ProductDetailMocks.product,
            );
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class ProductDetailCheckoutEvtEqualityScenario
    extends TAUTScenario<ProductDetailCheckoutEvt, bool> {
  ProductDetailCheckoutEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test equality of ProductDetailCheckoutEvt
          Given two ProductDetailCheckoutEvt event
          When comparing them
          Then they should be equal
          ''',
          when: () async {
            return ProductDetailCheckoutEvt(
              product: ProductDetailMocks.product,
            );
          },
          act: (event) =>
              event ==
              ProductDetailCheckoutEvt(
                product: ProductDetailMocks.product,
              ),
          expect: (bool result) {
            expect(result, isTrue);
          },
        );
}

class ProductDetailToggleWishListEvtPropsScenario
    extends TAUTScenario<ProductDetailToggleWishListEvt, List<Object?>> {
  ProductDetailToggleWishListEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test ProductDetailToggleWishListEvt Props
            Given ProductDetailToggleWishListEvt event
            When creating a ProductDetailToggleWishListEvt event and accessing props
            Then the props should not be empty
            ''',
          when: () async {
            return ProductDetailToggleWishListEvt(
              productId: 1,
            );
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [1]);
          },
        );
}
