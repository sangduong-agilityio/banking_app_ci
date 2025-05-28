import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/pages/auth/sign_in/states/sign_in_event.dart';

import '../../../helper/utils.dart';
import '../../auth_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });
  TAUnitTest(
    description: 'SignInEvent Tests',
    features: [
      TAUTFeature(
        description: 'SignInFormValidateChangedEvt',
        scenarios: [
          SignInFormValidateChangedPropsScenario(),
          SignInFormValidateChangedSuccessScenario(),
          SignInFormValidateChangedFailureScenario(),
          SignInFormValidateChangedEmptyScenario(),
          SignInFormValidateChangedEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'SignInButtonPressedEvt',
        scenarios: [
          SignInButtonPressedSuccessScenario(),
          SignInButtonPressedEqualityScenario(),
        ],
      ),
    ],
  ).test();
}

class SignInFormValidateChangedPropsScenario
    extends TAUTScenario<SignInEvt, List<Object?>> {
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
            expect(
              result,
              equals(
                [
                  'test@example.com',
                  'password123',
                  true,
                ],
              ),
            );
          },
        );
}

class SignInFormValidateChangedSuccessScenario
    extends TAUTScenario<SignInEvt, List<Object?>> {
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
              expect(
                result,
                equals(
                  [
                    'test@example.com',
                    'password123',
                    true,
                  ],
                ),
              );
            });
}

class SignInFormValidateChangedFailureScenario
    extends TAUTScenario<SignInEvt, List<Object?>> {
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
            expect(
              result,
              equals(
                [
                  null,
                  null,
                  false,
                ],
              ),
            );
          },
        );
}

class SignInFormValidateChangedEmptyScenario
    extends TAUTScenario<SignInEvt, bool> {
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
    extends TAUTScenario<SignInEvt, bool> {
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

class SignInButtonPressedSuccessScenario extends TAUTScenario<SignInEvt, bool> {
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

class SignInButtonPressedEqualityScenario
    extends TAUTScenario<SignInEvt, bool> {
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
