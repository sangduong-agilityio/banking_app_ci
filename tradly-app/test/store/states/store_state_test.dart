import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/pages/store/states/store_state.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'StoreState Test',
    features: [
      TAUTFeature(
        description: 'StoreState',
        scenarios: [
          StoreStatePropsScenario(),
          StoreStateEqualityScenario(),
          StoreStateCopyWithScenario(),
          StoreStateDefaultValuesScenario(),
          StoreStateToStringScenario(),
          StoreStateCopyWithStatusScenario(),
        ],
      ),
    ],
  ).test();
}

class StoreStatePropsScenario extends TAUTScenario<StoreState, StoreState> {
  StoreStatePropsScenario()
      : super(
          description: '''
           Scenario: Test StoreState PropsScenario
            Given StoreState instance
            When accessing props
            Then it should return the correct values
          ''',
          when: () async {
            return StoreState(
              status: const StoreStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const StoreStatus.success(),
          ),
          expect: (StoreState result) {
            expect(
              result.status == const StoreStatus.success(),
              isTrue,
            );
          },
        );
}

class StoreStateEqualityScenario extends TAUTScenario<StoreState, StoreState> {
  StoreStateEqualityScenario()
      : super(
          description: '''
           Scenario: Test StoreState Equality
            Given two StoreState instances with the same properties
            When checking for equality
            Then it should return true
          ''',
          when: () async {
            return StoreState(
              status: const StoreStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (result) => result,
          expect: (StoreState result) {
            expect(result == result, isTrue);
          },
        );
}

class StoreStateCopyWithScenario extends TAUTScenario<StoreState, StoreState> {
  StoreStateCopyWithScenario()
      : super(
          description: '''
           Scenario: Test StoreState CopyWith
            Given a StoreState instance
            When using copyWith to modify properties
            Then it should return a new instance with updated properties
          ''',
          when: () async {
            return StoreState(
              status: const StoreStatus.initial(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const StoreStatus.success(),
            errorMessage: 'new error',
          ),
          expect: (StoreState result) {
            expect(result.status, const StoreStatus.success());
            expect(result.errorMessage, 'new error');
          },
        );
}

class StoreStateDefaultValuesScenario
    extends TAUTScenario<StoreState, StoreState> {
  StoreStateDefaultValuesScenario()
      : super(
          description: '''
           Scenario: Test StoreState Default Values
            Given a StoreState instance with default values
            When accessing properties
            Then it should return the default values
          ''',
          when: () async {
            return const StoreState();
          },
          act: (state) => state,
          expect: (StoreState result) {
            expect(result.status, const StoreStatus.initial());
            expect(result.errorMessage, isNull);
            expect(result.products, isNull);
          },
        );
}

class StoreStateToStringScenario extends TAUTScenario<StoreState, String> {
  StoreStateToStringScenario()
      : super(
          description: '''
           Scenario: Test StoreState toString method
            Given a StoreState instance
            When calling toString
            Then it should return a string representation of the state
          ''',
          when: () async {
            return StoreState(
              status: const StoreStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.toString(),
          expect: (String result) {
            expect(result,
                'StoreState(false, false, null, null, null, StoreStatus.success(), error, false, false, null)');
          },
        );
}

class StoreStateCopyWithStatusScenario
    extends TAUTScenario<StoreState, StoreState> {
  StoreStateCopyWithStatusScenario()
      : super(
          description: '''
           Scenario: Test StoreState copyWith with status
            Given a StoreState instance
            When using copyWith to modify status
            Then it should return a new instance with updated status
          ''',
          when: () async {
            return StoreState(
              status: const StoreStatus.initial(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const StoreStatus.loading(),
          ),
          expect: (StoreState result) {
            expect(result.status, const StoreStatus.loading());
          },
        );
}
