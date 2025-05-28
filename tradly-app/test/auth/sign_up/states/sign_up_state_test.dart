import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/pages/auth/sign_up/states/sign_up_state.dart';

import '../../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'SignUpState Test',
    features: [
      TAUTFeature(
        description: 'SignUpState Test',
        scenarios: [
          SignUpStatePropScenario(),
          SignUpStateEqualityScenario(),
          SignUpStateCopyWithScenario(),
          SignUpStateDefaultValuesScenario(),
          SignUpStateCopyWithStatusScenario(),
          SignUpStateCopyWithNullStatusScenario(),
        ],
      ),
    ],
  ).test();
}

class SignUpStatePropScenario extends TAUTScenario<SignUpState, List<Object?>> {
  SignUpStatePropScenario()
      : super(
          description: '''
          Scenario: Test SignUpState properties
          Given a SignUpState instance
          When accessing props
          Then it should return the correct list of properties
          ''',
          when: () async {
            return const SignUpState();
          },
          act: (state) => state.props,
          expect: (List<Object?> result) {
            expect(
              result,
              equals(
                [
                  SignUpStatus.initial(),
                  '',
                  '',
                  '',
                  '',
                  false,
                  null,
                ],
              ),
            );
          },
        );
}

class SignUpStateEqualityScenario extends TAUTScenario<SignUpState, bool> {
  SignUpStateEqualityScenario()
      : super(
          description: '''
          Scenario: Test SignUpState equality
          Given two identical SignUpState instances
          When comparing them for equality
          Then they should be equal
          ''',
          when: () async {
            return const SignUpState();
          },
          act: (state) => state == const SignUpState(),
          expect: (bool result) {
            expect(result, isTrue);
          },
        );
}

class SignUpStateCopyWithScenario
    extends TAUTScenario<SignUpState, SignUpState> {
  SignUpStateCopyWithScenario()
      : super(
          description: '''
          Scenario: Test SignUpState copyWith
          Given a SignUpState instance
          When copying it with a new status
          Then it should return a new SignUpState instance with the new status
          ''',
          when: () async {
            return const SignUpState();
          },
          act: (state) => state.copyWith(status: const SignUpStatus.loading()),
          expect: (SignUpState result) {
            expect(result.status, equals(const SignUpStatus.loading()));
          },
        );
}

class SignUpStateDefaultValuesScenario
    extends TAUTScenario<SignUpState, SignUpState> {
  SignUpStateDefaultValuesScenario()
      : super(
          description: '''
          Scenario: Test SignUpState default values
          Given a new SignUpState instance
          When accessing its properties
          Then it should have default values
          ''',
          when: () async {
            return const SignUpState();
          },
          act: (state) => state,
          expect: (SignUpState result) {
            expect(result.username, equals(''));
            expect(result.emailOrPhoneNumber, equals(''));
            expect(result.password, equals(''));
            expect(result.confirmPassword, equals(''));
            expect(result.isFormValid, isFalse);
            expect(result.errorMessage, isNull);
          },
        );
}

class SignUpStateCopyWithStatusScenario
    extends TAUTScenario<SignUpState, SignUpState> {
  SignUpStateCopyWithStatusScenario()
      : super(
          description: '''
          Scenario: Test SignUpState copyWith with status
          Given a SignUpState instance
          When copying it with a new status
          Then it should return a new SignUpState instance with the new status
          ''',
          when: () async {
            return const SignUpState();
          },
          act: (state) => state.copyWith(status: const SignUpStatus.success()),
          expect: (SignUpState result) {
            expect(result.status, equals(const SignUpStatus.success()));
          },
        );
}

class SignUpStateCopyWithNullStatusScenario
    extends TAUTScenario<SignUpState, SignUpState> {
  SignUpStateCopyWithNullStatusScenario()
      : super(
          description: '''
          Scenario: Test SignUpState copyWith with null status
          Given a SignUpState instance
          When copying it with a null status
          Then it should return a new SignUpState instance with the same properties
          ''',
          when: () async {
            return const SignUpState();
          },
          act: (state) => state.copyWith(status: null),
          expect: (SignUpState result) {
            expect(result.status, equals(const SignUpStatus.initial()));
            expect(result.username, equals(''));
            expect(result.emailOrPhoneNumber, equals(''));
            expect(result.password, equals(''));
            expect(result.confirmPassword, equals(''));
            expect(result.isFormValid, isFalse);
            expect(result.errorMessage, isNull);
          },
        );
}
