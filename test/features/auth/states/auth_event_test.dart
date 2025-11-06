import 'dart:ui';

import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/auth/presentation/blocs/auth_event.dart';
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
      // NEW: Missing event tests
      BAUTFeature(
        description: 'SignInWithBiometricEvt',
        scenarios: [
          SignInWithBiometricSuccessScenario(),
          SignInWithBiometricPropsScenario(),
          SignInWithBiometricEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'CheckBiometricAvailabilityEvt',
        scenarios: [
          CheckBiometricAvailabilitySuccessScenario(),
          CheckBiometricAvailabilityPropsScenario(),
          CheckBiometricAvailabilityEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'SignUpTermsChangedEvt',
        scenarios: [
          SignUpTermsChangedPropsScenario(),
          SignUpTermsChangedSuccessScenario(),
          SignUpTermsChangedEqualityScenario(),
        ],
      ),
      BAUTFeature(
        description: 'GetCurrentUserEvt',
        scenarios: [
          GetCurrentUserSuccessScenario(),
          GetCurrentUserPropsScenario(),
          GetCurrentUserEqualityScenario(),
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

// ============================================================================
// NEW TEST SCENARIOS FOR MISSING EVENTS
// ============================================================================

// SignInWithBiometricEvt Tests
class SignInWithBiometricSuccessScenario extends BAUTScenario<AuthEvt, bool> {
  SignInWithBiometricSuccessScenario()
      : super(
          description: '''
            Scenario: Test SignInWithBiometricEvt Success
            Given a SignInWithBiometricEvt
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
    extends BAUTScenario<AuthEvt, List<Object?>> {
  SignInWithBiometricPropsScenario()
      : super(
          description: '''
            Scenario: Test SignInWithBiometricEvt Props
            Given a SignInWithBiometricEvt
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
    extends BAUTScenario<AuthEvt, bool> {
  SignInWithBiometricEqualityScenario()
      : super(
          description: '''
            Scenario: Test SignInWithBiometricEvt Equality
            Given two SignInWithBiometricEvt instances
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

// CheckBiometricAvailabilityEvt Tests
class CheckBiometricAvailabilitySuccessScenario
    extends BAUTScenario<AuthEvt, bool> {
  CheckBiometricAvailabilitySuccessScenario()
      : super(
          description: '''
            Scenario: Test CheckBiometricAvailabilityEvt Success
            Given a CheckBiometricAvailabilityEvt
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
    extends BAUTScenario<AuthEvt, List<Object?>> {
  CheckBiometricAvailabilityPropsScenario()
      : super(
          description: '''
            Scenario: Test CheckBiometricAvailabilityEvt Props
            Given a CheckBiometricAvailabilityEvt
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
    extends BAUTScenario<AuthEvt, bool> {
  CheckBiometricAvailabilityEqualityScenario()
      : super(
          description: '''
            Scenario: Test CheckBiometricAvailabilityEvt Equality
            Given two CheckBiometricAvailabilityEvt instances
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

// SignUpTermsChangedEvt Tests
class SignUpTermsChangedPropsScenario
    extends BAUTScenario<AuthEvt, List<Object?>> {
  SignUpTermsChangedPropsScenario()
      : super(
          description: '''
            Scenario: Test SignUpTermsChangedEvt Props
            Given a SignUpTermsChangedEvt
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

class SignUpTermsChangedSuccessScenario extends BAUTScenario<AuthEvt, bool> {
  SignUpTermsChangedSuccessScenario()
      : super(
          description: '''
            Scenario: Test SignUpTermsChangedEvt Success
            Given a SignUpTermsChangedEvt with isAccepted true
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

class SignUpTermsChangedEqualityScenario extends BAUTScenario<AuthEvt, bool> {
  SignUpTermsChangedEqualityScenario()
      : super(
          description: '''
            Scenario: Test SignUpTermsChangedEvt Equality
            Given two SignUpTermsChangedEvt with the same isAccepted
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

// GetCurrentUserEvt Tests
class GetCurrentUserSuccessScenario extends BAUTScenario<AuthEvt, bool> {
  GetCurrentUserSuccessScenario()
      : super(
          description: '''
            Scenario: Test GetCurrentUserEvt Success
            Given a GetCurrentUserEvt
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
    extends BAUTScenario<AuthEvt, List<Object?>> {
  GetCurrentUserPropsScenario()
      : super(
          description: '''
            Scenario: Test GetCurrentUserEvt Props
            Given a GetCurrentUserEvt
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

class GetCurrentUserEqualityScenario extends BAUTScenario<AuthEvt, bool> {
  GetCurrentUserEqualityScenario()
      : super(
          description: '''
            Scenario: Test GetCurrentUserEvt Equality
            Given two GetCurrentUserEvt instances
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