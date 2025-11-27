import 'dart:ui';

import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  BAUnitTest(
    description: 'AuthState Test',
    features: [
      BAUTFeature(
        description: 'AuthState Test',
        scenarios: [
          AuthStatePropScenario(),
          AuthStateEqualityScenario(),
          AuthStateCopyWithScenario(),
          AuthStateDefaultValuesScenario(),
          AuthStateCopyWithStatusScenario(),
          AuthStateCopyWithNullStatusScenario(),
        ],
      ),
    ],
  ).test();
}

class AuthStatePropScenario extends BAUTScenario<AuthState, List<Object?>> {
  AuthStatePropScenario()
    : super(
        description: '''
          Scenario: Test AuthState properties
          Given a AuthState instance
          When accessing props
          Then it should return the correct list of properties
          ''',
        when: () async {
          return const AuthState();
        },
        act: (state) => state.props,
        expect: (List<Object?> result) {
          expect(
            result,
            equals([
              AuthStatus.initial,
              '',
              '',
              '',
              false,
              false,
              null,
              null,
              false,
              false,
              false,
              null,
              false
            ]),
          );
        },
      );
}

class AuthStateEqualityScenario extends BAUTScenario<AuthState, bool> {
  AuthStateEqualityScenario()
    : super(
        description: '''
          Scenario: Test AuthState equality
          Given two identical AuthState instances
          When comparing them for equality
          Then they should be equal
          ''',
        when: () async {
          return const AuthState();
        },
        act: (state) => state == const AuthState(),
        expect: (bool result) {
          expect(result, isTrue);
        },
      );
}

class AuthStateCopyWithScenario extends BAUTScenario<AuthState, AuthState> {
  AuthStateCopyWithScenario()
    : super(
        description: '''
          Scenario: Test AuthState copyWith
          Given a AuthState instance
          When copying it with a new status
          Then it should return a new AuthState instance with the new status
          ''',
        when: () async {
          return const AuthState();
        },
        act: (state) => state.copyWith(status: AuthStatus.loading),
        expect: (AuthState result) {
          expect(result.status, equals(AuthStatus.loading));
        },
      );
}

class AuthStateDefaultValuesScenario
    extends BAUTScenario<AuthState, AuthState> {
  AuthStateDefaultValuesScenario()
    : super(
        description: '''
          Scenario: Test AuthState default values
          Given a new AuthState instance
          When accessing its properties
          Then it should have default values
          ''',
        when: () async {
          return const AuthState();
        },
        act: (state) => state,
        expect: (AuthState result) {
          expect(result.email, equals(''));
          expect(result.password, equals(''));
          expect(result.isFormValid, isFalse);
          expect(result.errorMessage, isNull);
        },
      );
}

class AuthStateCopyWithStatusScenario
    extends BAUTScenario<AuthState, AuthState> {
  AuthStateCopyWithStatusScenario()
    : super(
        description: '''
          Scenario: Test AuthState copyWith with status
          Given a AuthState instance
          When copying it with a new status
          Then it should return a new AuthState instance with the new status
          ''',
        when: () async {
          return const AuthState();
        },
        act: (state) => state.copyWith(status: AuthStatus.success),
        expect: (AuthState result) {
          expect(result.status, equals(AuthStatus.success));
        },
      );
}

class AuthStateCopyWithNullStatusScenario
    extends BAUTScenario<AuthState, AuthState> {
  AuthStateCopyWithNullStatusScenario()
    : super(
        description: '''
          Scenario: Test AuthState copyWith with null status
          Given a AuthState instance
          When copying it with a null status
          Then it should return a new AuthState instance with the same properties
          ''',
        when: () async {
          return const AuthState();
        },
        act: (state) => state.copyWith(status: null),
        expect: (AuthState result) {
          expect(result.status, equals(AuthStatus.initial));
          expect(result.email, equals(''));
          expect(result.password, equals(''));
          expect(result.isFormValid, isFalse);
          expect(result.errorMessage, isNull);
        },
      );
}
