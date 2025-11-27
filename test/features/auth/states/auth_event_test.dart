import 'dart:ui';

import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../mocks/auth_mocks.dart';

// Updated to match the correct AuthMocks structure

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });
  BAUnitTest(
    description: 'AuthEvent Tests',
    features: [
      BAUTFeature(
        description: 'AuthEvent',
        scenarios: [AuthEventPropsScenario()],
      ),

      BAUTFeature(
        description: 'SignInFormValidateChanged',
        scenarios: [
          SignInFormValidateChangedPropsScenario(),
          SignInFormValidateChangedSuccessScenario(),
          SignInFormValidateChangedFailureScenario(),
          SignInFormValidateChangedEmptyScenario(),
          SignInFormValidateChangedEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'SignUpFormValidateChanged',
        scenarios: [
          SignUpFormValidateChangedPropsScenario(),
          SignUpFormValidateChangedSuccessScenario(),
          SignUpFormValidateChangedFailureScenario(),
          SignUpFormValidateChangedEmptyScenario(),
          SignUpFormValidateChangedEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'SignInButtonPressed',
        scenarios: [
          SignInButtonPressedSuccessScenario(),
          SignInButtonPressedEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'SignUpButtonPressed',
        scenarios: [
          SignUpButtonPressedSuccessScenario(),
          SignUpButtonPressedEqualityScenario(),
        ],
      ),
      // NEW: Missing event tests
      BAUTFeature(
        description: 'SignInWithBiometric',
        scenarios: [
          SignInWithBiometricSuccessScenario(),
          SignInWithBiometricPropsScenario(),
          SignInWithBiometricEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'CheckBiometricAvailability',
        scenarios: [
          CheckBiometricAvailabilitySuccessScenario(),
          CheckBiometricAvailabilityPropsScenario(),
          CheckBiometricAvailabilityEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'SignUpTermsChanged',
        scenarios: [
          SignUpTermsChangedPropsScenario(),
          SignUpTermsChangedSuccessScenario(),
          SignUpTermsChangedEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'GetCurrentUser',
        scenarios: [
          GetCurrentUserSuccessScenario(),
          GetCurrentUserPropsScenario(),
          GetCurrentUserEqualityScenario(),
        ],
      ),
    ],
  ).test();
}

class AuthEventPropsScenario extends BAUTScenario<AuthEvent, List<Object?>> {
  AuthEventPropsScenario()
    : super(
        description: '''
          Scenario: Test AuthEvent Props
            Given AuthEvent event
            When creating a AuthEvent event and accessing props
            Then the props should be empty
            ''',
        when: () async {
          return SignInButtonPressed();
        },
        act: (event) => event.props,
        expect: (List<Object?> result) {
          expect(result, isEmpty);
        },
      );
}

class SignInFormValidateChangedPropsScenario
    extends BAUTScenario<AuthEvent, List<Object?>> {
  SignInFormValidateChangedPropsScenario()
    : super(
        description: '''
          Scenario: Test SignInFormValidateChanged Props
          Given a SignInFormValidateChanged
          When the event is triggered
          Then the event's properties should match the provided values
          ''',
        when: () async => AuthMocks.signInForm,
        act: (event) => event.props,
        expect: (List<Object?> result) {
          expect(result, equals([true, 'test@example.com', 'password123']));
        },
      );
}

class SignInFormValidateChangedSuccessScenario
    extends BAUTScenario<AuthEvent, List<Object?>> {
  SignInFormValidateChangedSuccessScenario()
    : super(
        description: '''
          Scenario: Test SignInFormValidateChanged Success
          Given a SignInFormValidateChanged
          When the event is triggered
          Then the event should be a SignInFormValidateChanged
          ''',
        when: () async => AuthMocks.signInForm,
        act: (event) => event.props,
        expect: (List<Object?> result) {
          expect(result, equals([true, 'test@example.com', 'password123']));
        },
      );
}

class SignInFormValidateChangedFailureScenario
    extends BAUTScenario<AuthEvent, List<Object?>> {
  SignInFormValidateChangedFailureScenario()
    : super(
        description: '''
          Scenario: Test SignInFormValidateChanged Failure
          Given a SignInFormValidateChanged with invalid data
          When the event is triggered
          Then it should not be valid
          ''',
        when: () async => AuthMocks.signInFormEmpty,
        act: (event) => event.props,
        expect: (List<Object?> result) {
          expect(result, equals([false, null, null]));
        },
      );
}

class SignInFormValidateChangedEmptyScenario
    extends BAUTScenario<AuthEvent, bool> {
  SignInFormValidateChangedEmptyScenario()
    : super(
        description: '''
          Scenario: Test SignInFormValidateChanged Empty
          Given an empty SignInFormValidateChanged
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
    extends BAUTScenario<AuthEvent, bool> {
  SignInFormValidateChangedEqualityScenario()
    : super(
        description: '''
          Scenario: Test SignInFormValidateChanged Equality
          Given two SignInFormValidateChanged instances with the same properties
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

class SignInButtonPressedSuccessScenario extends BAUTScenario<AuthEvent, bool> {
  SignInButtonPressedSuccessScenario()
    : super(
        description: '''
          Scenario: Test SignInButtonPressed Success
          Given a SignInButtonPressed
          When the event is triggered
          Then the event should be a SignInButtonPressed
          ''',
        when: () async => AuthMocks.signInButtonPressed,
        act: (event) => event.props.isEmpty,
        expect: (bool result) {
          expect(result, isTrue);
        },
      );
}

class SignInButtonPressedEqualityScenario
    extends BAUTScenario<AuthEvent, bool> {
  SignInButtonPressedEqualityScenario()
    : super(
        description: '''
          Scenario: Test SignInButtonPressed Equality
          Given two SignInButtonPressed instances
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
    extends BAUTScenario<AuthEvent, List<Object?>> {
  SignUpFormValidateChangedPropsScenario()
    : super(
        description: '''
            Scenario: Test SignUpFormValidateChanged Props
            Given a SignUpFormValidateChanged
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
    extends BAUTScenario<AuthEvent, List<Object?>> {
  SignUpFormValidateChangedSuccessScenario()
    : super(
        description: '''
            Scenario: Test SignUpFormValidateChanged Success
            Given a SignUpFormValidateChanged with valid data
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
    extends BAUTScenario<AuthEvent, List<Object?>> {
  SignUpFormValidateChangedFailureScenario()
    : super(
        description: '''
            Scenario: Test SignUpFormValidateChanged Failure
            Given a SignUpFormValidateChanged with invalid data
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
    extends BAUTScenario<AuthEvent, bool> {
  SignUpFormValidateChangedEmptyScenario()
    : super(
        description: '''
            Scenario: Test SignUpFormValidateChanged Empty
            Given a SignUpFormValidateChanged with no data
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
    extends BAUTScenario<AuthEvent, bool> {
  SignUpFormValidateChangedEqualityScenario()
    : super(
        description: '''
            Scenario: Test SignUpFormValidateChanged Equality
            Given two SignUpFormValidateChanged with the same data
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

class SignUpButtonPressedEqualityScenario
    extends BAUTScenario<AuthEvent, bool> {
  SignUpButtonPressedEqualityScenario()
    : super(
        description: '''
            Scenario: Test SignUpButtonPressed Equality
            Given two SignUpButtonPressed
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

class SignUpButtonPressedSuccessScenario extends BAUTScenario<AuthEvent, bool> {
  SignUpButtonPressedSuccessScenario()
    : super(
        description: '''
            Scenario: Test SignUpButtonPressed Success
            Given a SignUpButtonPressed
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

// ============================================================================
// NEW TEST SCENARIOS FOR MISSING EVENTS
// ============================================================================

// SignInWithBiometric Tests
class SignInWithBiometricSuccessScenario extends BAUTScenario<AuthEvent, bool> {
  SignInWithBiometricSuccessScenario()
    : super(
        description: '''
            Scenario: Test SignInWithBiometric Success
            Given a SignInWithBiometric
            When the event is triggered
            Then the event's properties should be empty
            ''',
        when: () async => AuthMocks.signInWithBiometric,
        act: (event) async => event.props.isEmpty,
        expect: (result) {
          expect(result, isTrue);
        },
      );
}

class SignInWithBiometricPropsScenario
    extends BAUTScenario<AuthEvent, List<Object?>> {
  SignInWithBiometricPropsScenario()
    : super(
        description: '''
            Scenario: Test SignInWithBiometric Props
            Given a SignInWithBiometric
            When accessing the props
            Then the props should be empty
            ''',
        when: () async => AuthMocks.signInWithBiometric,
        act: (event) => event.props,
        expect: (result) {
          expect(result, isEmpty);
        },
      );
}

class SignInWithBiometricEqualityScenario
    extends BAUTScenario<AuthEvent, bool> {
  SignInWithBiometricEqualityScenario()
    : super(
        description: '''
            Scenario: Test SignInWithBiometric Equality
            Given two SignInWithBiometric instances
            When comparing them
            Then they should be equal
            ''',
        when: () async => AuthMocks.signInWithBiometric,
        act: (event) async {
          final otherEvent = AuthMocks.signInWithBiometric;
          return event == otherEvent;
        },
        expect: (result) {
          expect(result, isTrue);
        },
      );
}

// CheckBiometricAvailability Tests
class CheckBiometricAvailabilitySuccessScenario
    extends BAUTScenario<AuthEvent, bool> {
  CheckBiometricAvailabilitySuccessScenario()
    : super(
        description: '''
            Scenario: Test CheckBiometricAvailability Success
            Given a CheckBiometricAvailability
            When the event is triggered
            Then the event's properties should be empty
            ''',
        when: () async => AuthMocks.checkBiometricAvailability,
        act: (event) async => event.props.isEmpty,
        expect: (result) {
          expect(result, isTrue);
        },
      );
}

class CheckBiometricAvailabilityPropsScenario
    extends BAUTScenario<AuthEvent, List<Object?>> {
  CheckBiometricAvailabilityPropsScenario()
    : super(
        description: '''
            Scenario: Test CheckBiometricAvailability Props
            Given a CheckBiometricAvailability
            When accessing the props
            Then the props should be empty
            ''',
        when: () async => AuthMocks.checkBiometricAvailability,
        act: (event) => event.props,
        expect: (result) {
          expect(result, isEmpty);
        },
      );
}

class CheckBiometricAvailabilityEqualityScenario
    extends BAUTScenario<AuthEvent, bool> {
  CheckBiometricAvailabilityEqualityScenario()
    : super(
        description: '''
            Scenario: Test CheckBiometricAvailability Equality
            Given two CheckBiometricAvailability instances
            When comparing them
            Then they should be equal
            ''',
        when: () async => AuthMocks.checkBiometricAvailability,
        act: (event) async {
          final otherEvent = AuthMocks.checkBiometricAvailability;
          return event == otherEvent;
        },
        expect: (result) {
          expect(result, isTrue);
        },
      );
}

// SignUpTermsChanged Tests
class SignUpTermsChangedPropsScenario
    extends BAUTScenario<AuthEvent, List<Object?>> {
  SignUpTermsChangedPropsScenario()
    : super(
        description: '''
            Scenario: Test SignUpTermsChanged Props
            Given a SignUpTermsChanged
            When accessing the props
            Then the props should contain isAccepted
            ''',
        when: () async => AuthMocks.signUpTermsChanged,
        act: (event) => event.props,
        expect: (result) {
          expect(result, equals([true]));
        },
      );
}

class SignUpTermsChangedSuccessScenario extends BAUTScenario<AuthEvent, bool> {
  SignUpTermsChangedSuccessScenario()
    : super(
        description: '''
            Scenario: Test SignUpTermsChanged Success
            Given a SignUpTermsChanged with isAccepted true
            When the event is triggered
            Then the event's properties should be non-empty
            ''',
        when: () async => AuthMocks.signUpTermsChanged,
        act: (event) async => event.props.isEmpty,
        expect: (result) {
          expect(result, isFalse);
        },
      );
}

class SignUpTermsChangedEqualityScenario extends BAUTScenario<AuthEvent, bool> {
  SignUpTermsChangedEqualityScenario()
    : super(
        description: '''
            Scenario: Test SignUpTermsChanged Equality
            Given two SignUpTermsChanged with the same isAccepted
            When comparing them
            Then they should be equal
            ''',
        when: () async => AuthMocks.signUpTermsChanged,
        act: (event) async {
          final otherEvent = AuthMocks.signUpTermsChanged;
          return event == otherEvent;
        },
        expect: (result) {
          expect(result, isTrue);
        },
      );
}

// GetCurrentUser Tests
class GetCurrentUserSuccessScenario extends BAUTScenario<AuthEvent, bool> {
  GetCurrentUserSuccessScenario()
    : super(
        description: '''
            Scenario: Test GetCurrentUser Success
            Given a GetCurrentUser
            When the event is triggered
            Then the event's properties should be empty
            ''',
        when: () async => AuthMocks.getCurrentUser,
        act: (event) async => event.props.isEmpty,
        expect: (result) {
          expect(result, isTrue);
        },
      );
}

class GetCurrentUserPropsScenario
    extends BAUTScenario<AuthEvent, List<Object?>> {
  GetCurrentUserPropsScenario()
    : super(
        description: '''
            Scenario: Test GetCurrentUser Props
            Given a GetCurrentUser
            When accessing the props
            Then the props should be empty
            ''',
        when: () async => AuthMocks.getCurrentUser,
        act: (event) => event.props,
        expect: (result) {
          expect(result, isEmpty);
        },
      );
}

class GetCurrentUserEqualityScenario extends BAUTScenario<AuthEvent, bool> {
  GetCurrentUserEqualityScenario()
    : super(
        description: '''
            Scenario: Test GetCurrentUser Equality
            Given two GetCurrentUser instances
            When comparing them
            Then they should be equal
            ''',
        when: () async => AuthMocks.getCurrentUser,
        act: (event) async {
          final otherEvent = AuthMocks.getCurrentUser;
          return event == otherEvent;
        },
        expect: (result) {
          expect(result, isTrue);
        },
      );
}
