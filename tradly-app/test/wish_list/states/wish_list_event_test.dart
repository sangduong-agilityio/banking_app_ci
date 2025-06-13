import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_event.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';

import '../../helper/utils.dart';
import '../wish_list_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });
  TAUnitTest(
    description: 'WishListEvt Test',
    features: [
      TAUTFeature(
        description: 'WishListEvt',
        scenarios: [
          WishListEvtPropsScenario(),
        ],
      ),
      TAUTFeature(
        description: 'FetchWishListEvt',
        scenarios: [
          FetchWishListEvtPropsScenario(),
        ],
      ),
      TAUTFeature(
        description: 'AddToWishListEvt',
        scenarios: [
          AddToWishListEvtPropsScenario(),
        ],
      ),
      TAUTFeature(
        description: 'RemoveFromWishListEvent',
        scenarios: [
          RemoveFromWishListEventPropsScenario(),
        ],
      ),
    ],
  ).test();
}

class WishListEvtPropsScenario
    extends TAUTScenario<WishListEvt, List<Object?>> {
  WishListEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test WishListEvt Props
            Given WishListEvt event
            When creating a WishListEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return WishListEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}

class FetchWishListEvtPropsScenario
    extends TAUTScenario<FetchWishListEvt, List<Object?>> {
  FetchWishListEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test FetchWishListEvt Props
            Given FetchWishListEvt event
            When creating a FetchWishListEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return FetchWishListEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}

class AddToWishListEvtPropsScenario
    extends TAUTScenario<AddToWishListEvt, List<Object?>> {
  AddToWishListEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test AddToWishListEvt Props
            Given AddToWishListEvt event with a product
            When creating an AddToWishListEvt event and accessing props
            Then the props should contain the product
            ''',
          when: () async {
            return AddToWishListEvt(product: WishListMocks.products);
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, hasLength(1));
            expect(result[0], isA<ProductModel>());
          },
        );
}

class RemoveFromWishListEventPropsScenario
    extends TAUTScenario<RemoveFromWishListEvent, List<Object?>> {
  RemoveFromWishListEventPropsScenario()
      : super(
          description: '''
          Scenario: Test RemoveFromWishListEvent Props
            Given RemoveFromWishListEvent event with a product
            When creating a RemoveFromWishListEvent event and accessing props
            Then the props should contain the product
            ''',
          when: () async {
            return RemoveFromWishListEvent(product: WishListMocks.products);
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, hasLength(1));
            expect(result[0], isA<ProductModel>());
          },
        );
}
