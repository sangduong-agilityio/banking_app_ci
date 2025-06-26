import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/order_history/states/order_history_state.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'OrderHistoryState Test',
    features: [
      TAUTFeature(
        description: 'OrderHistoryState',
        scenarios: [
          OrderHistoryStatePropsScenario(),
          OrderHistoryStateEqualityScenario(),
          OrderHistoryStateCopyWithScenario(),
          OrderHistoryStateDefaultValuesScenario(),
          OrderHistoryStateToStringScenario(),
          OrderHistoryStateCopyWithStatusScenario(),
        ],
      ),
    ],
  ).test();
}

class OrderHistoryStatePropsScenario
    extends TAUTScenario<OrderHistoryState, OrderHistoryState> {
  OrderHistoryStatePropsScenario()
      : super(
          description: '''
           Scenario: Test OrderHistoryState PropsScenario
            Given OrderHistoryState instance
            When accessing props
            Then it should return the correct values
          ''',
          when: () async {
            return const OrderHistoryState(products: []);
          },
          act: (state) => state.copyWith(products: []),
          expect: (OrderHistoryState result) {
            expect(result.products, isEmpty);
          },
        );
}

class OrderHistoryStateEqualityScenario
    extends TAUTScenario<OrderHistoryState, OrderHistoryState> {
  OrderHistoryStateEqualityScenario()
      : super(
          description: '''
           Scenario: Test OrderHistoryState Equality
            Given two OrderHistoryState instances with the same properties
            When comparing them for equality
            Then they should be equal
          ''',
          when: () async {
            return OrderHistoryState(
              products: [],
              status: const OrderHistoryStatus.success(),
            );
          },
          act: (result) => result,
          expect: (OrderHistoryState result) {
            expect(result == result, isTrue);
          },
        );
}

class OrderHistoryStateCopyWithScenario
    extends TAUTScenario<OrderHistoryState, OrderHistoryState> {
  OrderHistoryStateCopyWithScenario()
      : super(
          description: '''
           Scenario: Test OrderHistoryState CopyWith
            Given an OrderHistoryState instance
            When copying it with new properties
            Then it should return a new instance with updated properties
          ''',
          when: () async {
            final state = const OrderHistoryState(products: []);
            return state.copyWith(products: [
              ProductModel(price: '10', title: 'Test Product', imageUrl: '')
            ]);
          },
          act: (state) => state,
          expect: (OrderHistoryState result) {
            expect(result.products, hasLength(1));
            expect(result.products[0].title, 'Test Product');
          },
        );
}

class OrderHistoryStateDefaultValuesScenario
    extends TAUTScenario<OrderHistoryState, OrderHistoryState> {
  OrderHistoryStateDefaultValuesScenario()
      : super(
          description: '''
           Scenario: Test OrderHistoryState Default Values
            Given an OrderHistoryState instance with default values
            When accessing the default properties
            Then it should return the expected default values
          ''',
          when: () async {
            return const OrderHistoryState();
          },
          act: (state) => state,
          expect: (OrderHistoryState result) {
            expect(result.products, isEmpty);
          },
        );
}

class OrderHistoryStateToStringScenario
    extends TAUTScenario<OrderHistoryState, String> {
  OrderHistoryStateToStringScenario()
      : super(
          description: '''
           Scenario: Test OrderHistoryState toString
            Given an OrderHistoryState instance
            When calling toString
            Then it should return a string representation of the state
          ''',
          when: () async {
            return OrderHistoryState();
          },
          act: (state) => state.toString(),
          expect: (String result) {
            expect(result, contains('OrderHistoryState'));
          },
        );
}

class OrderHistoryStateCopyWithStatusScenario
    extends TAUTScenario<OrderHistoryState, OrderHistoryState> {
  OrderHistoryStateCopyWithStatusScenario()
      : super(
          description: '''
           Scenario: Test OrderHistoryState CopyWith with Status
            Given an OrderHistoryState instance with a specific status
            When copying it with a new status
            Then it should return a new instance with the updated status
          ''',
          when: () async {
            final state = const OrderHistoryState(
              status: OrderHistoryStatus.loading(),
            );
            return state.copyWith(
              status: const OrderHistoryStatus.success(),
            );
          },
          act: (state) => state,
          expect: (OrderHistoryState result) {
            expect(result.status, const OrderHistoryStatus.success());
          },
        );
}
