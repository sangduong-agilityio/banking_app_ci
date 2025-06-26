import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/order_history/states/order_history_event.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'OrderHistoryEvt Test',
    features: [
      TAUTFeature(
        description: 'OrderHistoryEvt',
        scenarios: [
          OrderHistoryEvtPropsScenario(),
        ],
      ),
      TAUTFeature(
        description: 'AddProductToOrderHistoryEvt',
        scenarios: [
          AddProductToOrderHistoryEvtPropsScenario(),
        ],
      ),
    ],
  ).test();
}

class OrderHistoryEvtPropsScenario
    extends TAUTScenario<OrderHistoryEvt, List<Object?>> {
  OrderHistoryEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test OrderHistoryEvt Props
            Given OrderHistoryEvt event
            When creating a OrderHistoryEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return OrderHistoryEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}

class AddProductToOrderHistoryEvtPropsScenario
    extends TAUTScenario<OrderHistoryEvt, List<Object?>> {
  AddProductToOrderHistoryEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test AddProductToOrderHistoryEvt Props
            Given AddProductToOrderHistoryEvt event with a product
            When creating a AddProductToOrderHistoryEvt event and accessing props
            Then the props should contain the product
            ''',
          when: () async {
            return AddProductToOrderHistoryEvt(
              product: ProductModel(
                  price: '10', title: 'Test Product', imageUrl: ''),
            );
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, hasLength(1));
            expect(result[0], isA<ProductModel>());
          },
        );
}
