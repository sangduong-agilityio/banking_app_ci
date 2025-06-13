import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_bloc.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_event.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_state.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';

import '../../helper/utils.dart';
import '../wish_list_mocks.dart';

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
        description: 'FetchWishListEvt',
        scenarios: [
          TABlocTestScenario<WishListBloc, WishListState>(
            description: '''
              Scenario: Test FetchWishListEvt emits success state with empty wishlist
                Given WishListBloc instance
                When FetchWishListEvt is added
                Then it should emit a success state with an empty wishlist
            ''',
            build: () => WishListBloc(),
            act: (bloc) => bloc.add(FetchWishListEvt()),
            expect: () => [
              const WishListState(
                wishlist: [],
                status: WishListStatus.success(),
              ),
            ],
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'AddToWishListEvt',
        scenarios: [
          TABlocTestScenario<WishListBloc, WishListState>(
            description: '''
              Scenario: Test AddToWishListEvt adds product to wishlist
                Given WishListBloc instance
                When AddToWishListEvt is added
                Then it should emit a success state with the product in the wishlist
            ''',
            build: () => WishListBloc(),
            act: (bloc) {
              final product = WishListMocks.products;
              bloc.add(AddToWishListEvt(product: product));
            },
            expect: () => [
              WishListState(
                wishlist: [WishListMocks.products],
                status: const WishListStatus.success(),
              ),
            ],
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'RemoveFromWishListEvent',
        scenarios: [
          TABlocTestScenario<WishListBloc, WishListState>(
            description: '''
              Scenario: Test RemoveFromWishListEvent removes product from wishlist
                Given WishListBloc instance
                When RemoveFromWishListEvent is added
                Then it should emit a success state with the product removed from the wishlist
            ''',
            build: () => WishListBloc(),
            act: (bloc) {
              final product = WishListMocks.products;
              bloc.add(AddToWishListEvt(product: product));
              bloc.add(RemoveFromWishListEvent(product: product));
            },
            expect: () => [
              WishListState(
                wishlist: [WishListMocks.products],
                status: const WishListStatus.success(),
              ),
              const WishListState(
                wishlist: [],
                status: WishListStatus.success(),
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
