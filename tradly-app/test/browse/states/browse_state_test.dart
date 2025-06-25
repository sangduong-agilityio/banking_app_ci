import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/features/browse/states/browse_state.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'BrowseState Test',
    features: [
      TAUTFeature(
        description: 'BrowseState',
        scenarios: [
          BrowseStatePropsScenario(),
          BrowseStateEqualityScenario(),
          BrowseStateCopyWithScenario(),
          BrowseStateDefaultValuesScenario(),
          BrowseStateToStringScenario(),
          BrowseStateCopyWithStatusScenario(),
        ],
      ),
    ],
  ).test();
}

class BrowseStatePropsScenario extends TAUTScenario<BrowseState, BrowseState> {
  BrowseStatePropsScenario()
      : super(
          description: '''
           Scenario: Test BrowseState PropsScenario
            Given BrowseState instance
            When accessing props
            Then it should return the correct values
          ''',
          when: () async {
            return BrowseState(
              status: const BrowseStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const BrowseStatus.success(),
          ),
          expect: (BrowseState result) {
            expect(
              result.status == const BrowseStatus.success(),
              isTrue,
            );
          },
        );
}

class BrowseStateEqualityScenario
    extends TAUTScenario<BrowseState, BrowseState> {
  BrowseStateEqualityScenario()
      : super(
          description: '''
           Scenario: Test BrowseState Equality
            Given two BrowseState instances with the same properties
            When checking for equality
            Then it should return true
          ''',
          when: () async {
            return BrowseState(
              status: const BrowseStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (result) => result,
          expect: (BrowseState result) {
            expect(result == result, isTrue);
          },
        );
}

class BrowseStateCopyWithScenario
    extends TAUTScenario<BrowseState, BrowseState> {
  BrowseStateCopyWithScenario()
      : super(
          description: '''
           Scenario: Test BrowseState CopyWith
            Given a BrowseState instance
            When using copyWith to modify properties
            Then it should return a new instance with updated properties
          ''',
          when: () async {
            return BrowseState(
              status: const BrowseStatus.initial(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const BrowseStatus.success(),
            errorMessage: 'new error',
          ),
          expect: (BrowseState result) {
            expect(result.status, const BrowseStatus.success());
            expect(result.errorMessage, 'new error');
          },
        );
}

class BrowseStateDefaultValuesScenario
    extends TAUTScenario<BrowseState, BrowseState> {
  BrowseStateDefaultValuesScenario()
      : super(
          description: '''
           Scenario: Test BrowseState Default Values
            Given a BrowseState instance with default values
            When accessing properties
            Then it should return the default values
          ''',
          when: () async {
            return const BrowseState();
          },
          act: (state) => state,
          expect: (BrowseState result) {
            expect(result.status, const BrowseStatus.initial());
            expect(result.errorMessage, isNull);
            expect(result.products, isNull);
          },
        );
}

class BrowseStateToStringScenario extends TAUTScenario<BrowseState, String> {
  BrowseStateToStringScenario()
      : super(
          description: '''
           Scenario: Test BrowseState toString method
            Given a BrowseState instance
            When calling toString
            Then it should return a string representation of the state
          ''',
          when: () async {
            return BrowseState(
              status: const BrowseStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.toString(),
          expect: (String result) {
            expect(result, 'BrowseState(null, BrowseStatus.success(), error)');
          },
        );
}

class BrowseStateCopyWithStatusScenario
    extends TAUTScenario<BrowseState, BrowseState> {
  BrowseStateCopyWithStatusScenario()
      : super(
          description: '''
           Scenario: Test BrowseState copyWith with status
            Given a BrowseState instance
            When using copyWith to modify status
            Then it should return a new instance with updated status
          ''',
          when: () async {
            return BrowseState(
              status: const BrowseStatus.initial(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const BrowseStatus.loading(),
          ),
          expect: (BrowseState result) {
            expect(result.status, const BrowseStatus.loading());
          },
        );
}
