import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_state.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });
  TAUnitTest(
    description: 'WishListState Test',
    features: [
      TAUTFeature(
        description: 'WishListState',
        scenarios: [
          WishListStatePropsScenario(),
          WishListStateEqualityScenario(),
          WishListStateCopyWithScenario(),
          WishListStateDefaultValuesScenario(),
          WishListStateToStringScenario(),
          WishListStateCopyWithStatusScenario(),
        ],
      ),
    ],
  ).test();
}

class WishListStatePropsScenario
    extends TAUTScenario<WishListState, WishListState> {
  WishListStatePropsScenario()
      : super(
          description: '''
           Scenario: Test WishListState PropsScenario
            Given WishListState instance
            When accessing props
            Then it should return the correct values
          ''',
          when: () async {
            return WishListState(
              status: const WishListStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const WishListStatus.success(),
          ),
          expect: (WishListState result) {
            expect(
              result.status == const WishListStatus.success(),
              isTrue,
            );
          },
        );
}

class WishListStateEqualityScenario
    extends TAUTScenario<WishListState, WishListState> {
  WishListStateEqualityScenario()
      : super(
          description: '''
           Scenario: Test WishListState Equality
            Given two WishListState instances with the same properties
            When checking for equality
            Then it should return true
          ''',
          when: () async {
            return WishListState(
              status: const WishListStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (result) => result,
          expect: (WishListState result) {
            expect(result == result, isTrue);
          },
        );
}

class WishListStateCopyWithScenario
    extends TAUTScenario<WishListState, WishListState> {
  WishListStateCopyWithScenario()
      : super(
          description: '''
           Scenario: Test WishListState CopyWith
            Given a WishListState instance
            When using copyWith to modify properties
            Then it should return a new instance with updated properties
          ''',
          when: () async {
            return WishListState(
              status: const WishListStatus.initial(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const WishListStatus.success(),
            errorMessage: 'new error',
          ),
          expect: (WishListState result) {
            expect(result.status, const WishListStatus.success());
            expect(result.errorMessage, 'new error');
          },
        );
}

class WishListStateDefaultValuesScenario
    extends TAUTScenario<WishListState, WishListState> {
  WishListStateDefaultValuesScenario()
      : super(
          description: '''
           Scenario: Test WishListState Default Values
            Given a WishListState instance with default values
            When accessing properties
            Then it should return the default values
          ''',
          when: () async {
            return const WishListState();
          },
          act: (state) => state,
          expect: (WishListState result) {
            expect(result.status, const WishListStatus.initial());
            expect(result.errorMessage, isNull);
            expect(result.wishlist, []);
          },
        );
}

class WishListStateToStringScenario
    extends TAUTScenario<WishListState, String> {
  WishListStateToStringScenario()
      : super(
          description: '''
           Scenario: Test WishListState toString method
            Given a WishListState instance
            When calling toString
            Then it should return a string representation of the state
          ''',
          when: () async {
            return WishListState(
              status: const WishListStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.toString(),
          expect: (String result) {
            expect(
                result, 'WishListState([], WishListStatus.success(), error)');
          },
        );
}

class WishListStateCopyWithStatusScenario
    extends TAUTScenario<WishListState, WishListState> {
  WishListStateCopyWithStatusScenario()
      : super(
          description: '''
           Scenario: Test WishListState copyWith with status
            Given a WishListState instance
            When using copyWith to modify status
            Then it should return a new instance with updated status
          ''',
          when: () async {
            return WishListState(
              status: const WishListStatus.initial(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const WishListStatus.loading(),
          ),
          expect: (WishListState result) {
            expect(result.status, const WishListStatus.loading());
          },
        );
}
