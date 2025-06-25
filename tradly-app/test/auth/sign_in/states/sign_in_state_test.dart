import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/features/auth/states/sign_in_state.dart';

import '../../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'SignInState Test',
    features: [
      TAUTFeature(
        description: 'SignInState Test',
        scenarios: [
          SignInStatePropScenario(),
          SignInStateEqualityScenario(),
          SignInStateCopyWithScenario(),
          SignInStateDefaultValuesScenario(),
          SignInStateCopyWithStatusScenario(),
          SignInStateCopyWithNullStatusScenario(),
        ],
      ),
    ],
  ).test();
}

class SignInStatePropScenario extends TAUTScenario<SignInState, List<Object?>> {
  SignInStatePropScenario()
      : super(
          description: '''
          Scenario: Test SignInState properties
          Given a SignInState instance
          When accessing props
          Then it should return the correct list of properties
          ''',
          when: () async {
            return const SignInState();
          },
          act: (state) => state.props,
          expect: (List<Object?> result) {
            expect(
              result,
              equals(
                [SignInStatus.initial(), null, false, '', '', '', null],
              ),
            );
          },
        );
}

class SignInStateEqualityScenario extends TAUTScenario<SignInState, bool> {
  SignInStateEqualityScenario()
      : super(
          description: '''
          Scenario: Test SignInState equality
          Given two identical SignInState instances
          When comparing them for equality
          Then they should be equal
          ''',
          when: () async {
            return const SignInState();
          },
          act: (state) => state == const SignInState(),
          expect: (bool result) {
            expect(result, isTrue);
          },
        );
}

class SignInStateCopyWithScenario
    extends TAUTScenario<SignInState, SignInState> {
  SignInStateCopyWithScenario()
      : super(
          description: '''
          Scenario: Test SignInState copyWith
          Given a SignInState instance
          When copying it with a new status
          Then it should return a new SignInState instance with the new status
          ''',
          when: () async {
            return const SignInState();
          },
          act: (state) => state.copyWith(status: const SignInStatus.loading()),
          expect: (SignInState result) {
            expect(result.status, equals(const SignInStatus.loading()));
          },
        );
}

class SignInStateDefaultValuesScenario
    extends TAUTScenario<SignInState, SignInState> {
  SignInStateDefaultValuesScenario()
      : super(
          description: '''
          Scenario: Test SignInState default values
          Given a new SignInState instance
          When accessing its properties
          Then it should have default values
          ''',
          when: () async {
            return const SignInState();
          },
          act: (state) => state,
          expect: (SignInState result) {
            expect(result.email, equals(''));
            expect(result.password, equals(''));
            expect(result.isFormValid, isFalse);
            expect(result.errorMessage, isNull);
          },
        );
}

class SignInStateCopyWithStatusScenario
    extends TAUTScenario<SignInState, SignInState> {
  SignInStateCopyWithStatusScenario()
      : super(
          description: '''
          Scenario: Test SignInState copyWith with status
          Given a SignInState instance
          When copying it with a new status
          Then it should return a new SignInState instance with the new status
          ''',
          when: () async {
            return const SignInState();
          },
          act: (state) => state.copyWith(status: const SignInStatus.success()),
          expect: (SignInState result) {
            expect(result.status, equals(const SignInStatus.success()));
          },
        );
}

class SignInStateCopyWithNullStatusScenario
    extends TAUTScenario<SignInState, SignInState> {
  SignInStateCopyWithNullStatusScenario()
      : super(
          description: '''
          Scenario: Test SignInState copyWith with null status
          Given a SignInState instance
          When copying it with a null status
          Then it should return a new SignInState instance with the same properties
          ''',
          when: () async {
            return const SignInState();
          },
          act: (state) => state.copyWith(status: null),
          expect: (SignInState result) {
            expect(result.status, equals(const SignInStatus.initial()));
            expect(result.email, equals(''));
            expect(result.password, equals(''));
            expect(result.isFormValid, isFalse);
            expect(result.errorMessage, isNull);
          },
        );
}
