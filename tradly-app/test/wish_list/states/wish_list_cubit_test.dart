import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_cubit.dart';

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
          FetchWishListEvtSuccessScenario(),
        ],
      ),
      TABlocTestFeature(
        description: 'AddToWishListEvt',
        scenarios: [
          AddToWishListEvtSuccessScenario(),
        ],
      ),
      TABlocTestFeature(
        description: 'RemoveFromWishListEvent',
        scenarios: [
          RemoveFromWishListEvtSuccessScenario(),
        ],
      ),
    ],
  ).test();
}

class FetchWishListEvtSuccessScenario
    extends TABlocTestScenario<WishListCubit, WishListState> {
  FetchWishListEvtSuccessScenario()
      : super(
          description: '''
            Scenario: Test FetchWishListEvt emits success state with empty wishlist
              Given WishListBloc instance
              When FetchWishListEvt is added
              Then it should emit a success state with an empty wishlist
          ''',
          build: () => WishListCubit(),
          act: (bloc) {
            bloc.fetchWishList();
          },
          expect: () => [
            const WishListState(
              wishlist: [],
              status: WishListStatus.success(),
            ),
          ],
        );
}

class AddToWishListEvtSuccessScenario
    extends TABlocTestScenario<WishListCubit, WishListState> {
  AddToWishListEvtSuccessScenario()
      : super(
          description: '''
            Scenario: Test AddToWishListEvt adds product to wishlist
              Given WishListBloc instance
              When AddToWishListEvt is added with a product
              Then it should emit a success state with the product in the wishlist
          ''',
          build: () => WishListCubit(),
          act: (bloc) {
            bloc.addToWishList(WishListMocks.products);
          },
          expect: () => [
            WishListState(
              wishlist: [WishListMocks.products],
              status: const WishListStatus.success(),
            ),
          ],
        );
}

class RemoveFromWishListEvtSuccessScenario
    extends TABlocTestScenario<WishListCubit, WishListState> {
  RemoveFromWishListEvtSuccessScenario()
      : super(
          description: '''
            Scenario: Test RemoveFromWishListEvt removes product from wishlist
              Given WishListBloc instance with a product in the wishlist
              When RemoveFromWishListEvt is added with the product
              Then it should emit a success state with an empty wishlist
          ''',
          build: () => WishListCubit(),
          act: (bloc) {
            bloc.addToWishList(WishListMocks.products);
            bloc.removeFromWishList(WishListMocks.products);
          },
          expect: () => [
            WishListState(
              wishlist: [WishListMocks.products],
              status: WishListStatus.success(),
            ),
            const WishListState(
              wishlist: [],
              status: WishListStatus.success(),
            ),
          ],
        );
}
