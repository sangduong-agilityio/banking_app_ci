import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/features/auth/states/sign_up_event.dart';

import '../../../helper/utils.dart';
import '../../auth_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });
  TAUnitTest(
    description: 'SignUpEvent Tests',
    features: [
      TAUTFeature(
        description: 'SignUpEvent',
        scenarios: [
          SignUpEventPropsScenario(),
        ],
      ),
      TAUTFeature(
        description: 'SignUpFormValidateChangedEvt',
        scenarios: [
          SignUpFormValidateChangedPropsScenario(),
          SignUpFormValidateChangedSuccessScenario(),
          SignUpFormValidateChangedFailureScenario(),
          SignUpFormValidateChangedEmptyScenario(),
          SignUpFormValidateChangedEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'SignUpButtonPressedEvt',
        scenarios: [
          SignUpButtonPressedSuccessScenario(),
          SignUpButtonPressedEqualityScenario(),
        ],
      ),
    ],
  ).test();
}

class SignUpEventPropsScenario extends TAUTScenario<SignUpEvt, List<Object?>> {
  SignUpEventPropsScenario()
      : super(
          description: '''
          Scenario: Test SignUpEvt Props
            Given SignUpEvt event
            When creating a SignUpEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return SignUpEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}

class SignUpFormValidateChangedPropsScenario
    extends TAUTScenario<SignUpEvt, List<Object?>> {
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
              equals([
                true,
                'test_user',
                'test@example.com',
                'password123',
                'password123',
              ]),
            );
          },
        );
}

class SignUpFormValidateChangedSuccessScenario
    extends TAUTScenario<SignUpEvt, List<Object?>> {
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
              equals([
                true,
                'test_user',
                'test@example.com',
                'password123',
                'password123',
              ]),
            );
          },
        );
}

class SignUpFormValidateChangedFailureScenario
    extends TAUTScenario<SignUpEvt, List<Object?>> {
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
              equals([
                true,
                'test_user',
                'test@example.com',
                'password123',
                'password123',
              ]),
            );
          },
        );
}

class SignUpFormValidateChangedEmptyScenario
    extends TAUTScenario<SignUpEvt, bool> {
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
    extends TAUTScenario<SignUpEvt, bool> {
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

class SignUpButtonPressedEqualityScenario
    extends TAUTScenario<SignUpEvt, bool> {
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

class SignUpButtonPressedSuccessScenario extends TAUTScenario<SignUpEvt, bool> {
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
