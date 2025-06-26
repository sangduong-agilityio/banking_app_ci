import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/order_history/states/order_history_bloc.dart';
import 'package:tradly_app/features/order_history/states/order_history_event.dart'
    show AddProductToOrderHistoryEvt;
import 'package:tradly_app/features/order_history/states/order_history_state.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    S.load(const Locale('en'));
  });

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
  });

  TABlocTest(
    description: 'WishListBloc Tests',
    features: [
      TABlocTestFeature(
        description: 'AddProductToOrderHistoryEvt',
        scenarios: [
          AddProductToOrderHistoryEvtSuccessScenario(),
        ],
      ),
    ],
  ).test();
}

class AddProductToOrderHistoryEvtSuccessScenario
    extends TABlocTestScenario<OrderHistoryBloc, OrderHistoryState> {
  AddProductToOrderHistoryEvtSuccessScenario()
      : super(
          description: '''
            Scenario: Test AddProductToOrderHistoryEvt emits success state with product
              Given OrderHistoryBloc instance
              When AddProductToOrderHistoryEvt is added with a product
              Then it should emit a success state with the product in the order history
          ''',
          build: () => OrderHistoryBloc(),
          act: (bloc) {
            bloc.add(AddProductToOrderHistoryEvt(
              product: ProductModel(
                title: 'Test Product',
                price: '100',
                imageUrl: 'https://example.com/image.jpg',
              ),
            ));
          },
          expect: () => [
            isA<OrderHistoryState>()
                .having((s) => s.products.length, 'products length', 1)
                .having(
                  (s) => s.products.first.title,
                  'product title',
                  'Test Product',
                )
                .having(
                  (s) => s.products.first.price,
                  'product price',
                  '100',
                )
                .having(
                  (s) => s.products.first.imageUrl,
                  'product imageUrl',
                  'https://example.com/image.jpg',
                ),
          ],
        );
}
