import 'dart:ui';

import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../mocks/auth_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });
  BAUnitTest(
    description: 'AuthEvt Tests',
    features: [
      BAUTFeature(description: 'AuthEvt', scenarios: [AuthEvtPropsScenario()]),

      BAUTFeature(
        description: 'SignInFormValidateChangedEvt',
        scenarios: [
          SignInFormValidateChangedPropsScenario(),
          SignInFormValidateChangedSuccessScenario(),
          SignInFormValidateChangedFailureScenario(),
          SignInFormValidateChangedEmptyScenario(),
          SignInFormValidateChangedEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'SignUpFormValidateChangedEvt',
        scenarios: [
          SignUpFormValidateChangedPropsScenario(),
          SignUpFormValidateChangedSuccessScenario(),
          SignUpFormValidateChangedFailureScenario(),
          SignUpFormValidateChangedEmptyScenario(),
          SignUpFormValidateChangedEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'SignInButtonPressedEvt',
        scenarios: [
          SignInButtonPressedSuccessScenario(),
          SignInButtonPressedEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'SignUpButtonPressedEvt',
        scenarios: [
          SignUpButtonPressedSuccessScenario(),
          SignUpButtonPressedEqualityScenario(),
        ],
      ),
    ],
  ).test();
}

class AuthEvtPropsScenario extends BAUTScenario<AuthEvt, List<Object?>> {
  AuthEvtPropsScenario()
    : super(
        description: '''
          Scenario: Test AuthEvt Props
            Given AuthEvt event
            When creating a AuthEvt event and accessing props
            Then the props should be empty
            ''',
        when: () async {
          return AuthEvt();
        },
        act: (event) => event.props,
        expect: (List<Object?> result) {
          expect(result, isEmpty);
        },
      );
}

class SignInFormValidateChangedPropsScenario
    extends BAUTScenario<AuthEvt, List<Object?>> {
  SignInFormValidateChangedPropsScenario()
    : super(
        description: '''
          Scenario: Test SignInFormValidateChangedEvt Props
          Given a SignInFormValidateChangedEvt
          When the event is triggered
          Then the event's properties should match the provided values
          ''',
        when: () async => AuthMocks.signInForm,
        act: (event) => event.props,
        expect: (List<Object?> result) {
          expect(result, equals(['test@example.com', 'password123', true]));
        },
      );
}

class SignInFormValidateChangedSuccessScenario
    extends BAUTScenario<AuthEvt, List<Object?>> {
  SignInFormValidateChangedSuccessScenario()
    : super(
        description: '''
          Scenario: Test SignInFormValidateChangedEvt Success
          Given a SignInFormValidateChangedEvt
          When the event is triggered
          Then the event should be a SignInFormValidateChangedEvt
          ''',
        when: () async => AuthMocks.signInForm,
        act: (event) => event.props,
        expect: (List<Object?> result) {
          expect(result, equals(['test@example.com', 'password123', true]));
        },
      );
}

class SignInFormValidateChangedFailureScenario
    extends BAUTScenario<AuthEvt, List<Object?>> {
  SignInFormValidateChangedFailureScenario()
    : super(
        description: '''
          Scenario: Test SignInFormValidateChangedEvt Failure
          Given a SignInFormValidateChangedEvt with invalid data
          When the event is triggered
          Then it should not be valid
          ''',
        when: () async => AuthMocks.signInFormEmpty,
        act: (event) => event.props,
        expect: (List<Object?> result) {
          expect(result, equals([null, null, false]));
        },
      );
}

class SignInFormValidateChangedEmptyScenario
    extends BAUTScenario<AuthEvt, bool> {
  SignInFormValidateChangedEmptyScenario()
    : super(
        description: '''
          Scenario: Test SignInFormValidateChangedEvt Empty
          Given an empty SignInFormValidateChangedEvt
          When the event is triggered
          Then it should not be valid
          ''',
        when: () async => AuthMocks.signInFormEmpty,
        act: (event) => event.props.isEmpty,
        expect: (bool result) {
          expect(result, isFalse);
        },
      );
}

class SignInFormValidateChangedEqualityScenario
    extends BAUTScenario<AuthEvt, bool> {
  SignInFormValidateChangedEqualityScenario()
    : super(
        description: '''
          Scenario: Test SignInFormValidateChangedEvt Equality
          Given two SignInFormValidateChangedEvt instances with the same properties
          When comparing them
          Then they should be equal
          ''',
        when: () async => AuthMocks.signInForm,
        act: (event) async {
          final otherEvent = AuthMocks.signInForm;
          return event == otherEvent;
        },
        expect: (bool result) {
          expect(result, isTrue);
        },
      );
}

class SignInButtonPressedSuccessScenario extends BAUTScenario<AuthEvt, bool> {
  SignInButtonPressedSuccessScenario()
    : super(
        description: '''
          Scenario: Test SignInButtonPressedEvt Success
          Given a SignInButtonPressedEvt
          When the event is triggered
          Then the event should be a SignInButtonPressedEvt
          ''',
        when: () async => AuthMocks.signInButtonPressed,
        act: (event) => event.props.isEmpty,
        expect: (bool result) {
          expect(result, isTrue);
        },
      );
}

class SignInButtonPressedEqualityScenario extends BAUTScenario<AuthEvt, bool> {
  SignInButtonPressedEqualityScenario()
    : super(
        description: '''
          Scenario: Test SignInButtonPressedEvt Equality
          Given two SignInButtonPressedEvt instances
          When comparing them
          Then they should be equal
          ''',
        when: () async => AuthMocks.signInButtonPressed,
        act: (event) async {
          final otherEvent = AuthMocks.signInButtonPressed;
          return event == otherEvent;
        },
        expect: (bool result) {
          expect(result, isTrue);
        },
      );
}

class SignUpFormValidateChangedPropsScenario
    extends BAUTScenario<AuthEvt, List<Object?>> {
  SignUpFormValidateChangedPropsScenario()
    : super(
        description: '''
            Scenario: Test SignUpFormValidateChangedEvt Props
            Given a SignUpFormValidateChangedEvt
            When the event is triggered
            Then the event's properties should match the provided values
            ''',
        when: () async => AuthMocks.signUpForm,
        act: (event) => event.props,
        expect: (List<Object?> result) {
          expect(
            result,
            equals([true, 'test_user', 'test@example.com', 'password123']),
          );
        },
      );
}

class SignUpFormValidateChangedSuccessScenario
    extends BAUTScenario<AuthEvt, List<Object?>> {
  SignUpFormValidateChangedSuccessScenario()
    : super(
        description: '''
            Scenario: Test SignUpFormValidateChangedEvt Success
            Given a SignUpFormValidateChangedEvt with valid data
            When the event is triggered
            Then the event's properties should match the provided values
            ''',
        when: () async => AuthMocks.signUpForm,
        act: (event) => event.props,
        expect: (List<Object?> result) {
          expect(
            result,
            equals([true, 'test_user', 'test@example.com', 'password123']),
          );
        },
      );
}

class SignUpFormValidateChangedFailureScenario
    extends BAUTScenario<AuthEvt, List<Object?>> {
  SignUpFormValidateChangedFailureScenario()
    : super(
        description: '''
            Scenario: Test SignUpFormValidateChangedEvt Failure
            Given a SignUpFormValidateChangedEvt with invalid data
            When the event is triggered
            Then the event's properties should match the provided values
            ''',
        when: () async => AuthMocks.signUpForm,
        act: (event) => event.props,
        expect: (List<Object?> result) {
          expect(
            result,
            equals([true, 'test_user', 'test@example.com', 'password123']),
          );
        },
      );
}

class SignUpFormValidateChangedEmptyScenario
    extends BAUTScenario<AuthEvt, bool> {
  SignUpFormValidateChangedEmptyScenario()
    : super(
        description: '''
            Scenario: Test SignUpFormValidateChangedEvt Empty
            Given a SignUpFormValidateChangedEvt with no data
            When the event is triggered
            Then the event's properties should be empty
            ''',
        when: () async => AuthMocks.signUpFormEmpty,
        act: (event) async => event.props.isEmpty,
        expect: (result) {
          expect(result, isFalse);
        },
      );
}

class SignUpFormValidateChangedEqualityScenario
    extends BAUTScenario<AuthEvt, bool> {
  SignUpFormValidateChangedEqualityScenario()
    : super(
        description: '''
            Scenario: Test SignUpFormValidateChangedEvt Equality
            Given two SignUpFormValidateChangedEvt with the same data
            When the events are compared
            Then they should be equal
            ''',
        when: () async => AuthMocks.signUpForm,
        act: (event) async {
          final otherEvent = AuthMocks.signUpForm;
          return event == otherEvent;
        },
        expect: (result) {
          expect(result, isTrue);
        },
      );
}

class SignUpButtonPressedEqualityScenario extends BAUTScenario<AuthEvt, bool> {
  SignUpButtonPressedEqualityScenario()
    : super(
        description: '''
            Scenario: Test SignUpButtonPressedEvt Equality
            Given two SignUpButtonPressedEvt
            When the events are compared
            Then they should be equal
            ''',
        when: () async => AuthMocks.signUpButtonPressed,
        act: (event) async {
          final otherEvent = AuthMocks.signUpButtonPressed;
          return event == otherEvent;
        },
        expect: (result) {
          expect(result, isTrue);
        },
      );
}

class SignUpButtonPressedSuccessScenario extends BAUTScenario<AuthEvt, bool> {
  SignUpButtonPressedSuccessScenario()
    : super(
        description: '''
            Scenario: Test SignUpButtonPressedEvt Success
            Given a SignUpButtonPressedEvt
            When the event is triggered
            Then the event's properties should be empty
            ''',
        when: () async => AuthMocks.signUpButtonPressed,
        act: (event) async => event.props.isEmpty,
        expect: (result) {
          expect(result, isTrue);
        },
      );
}
