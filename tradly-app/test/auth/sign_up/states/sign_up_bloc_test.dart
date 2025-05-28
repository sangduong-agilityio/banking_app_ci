import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/pages/auth/sign_up/states/sign_up_bloc.dart';
import 'package:tradly_app/presentations/pages/auth/sign_up/states/sign_up_event.dart';
import 'package:tradly_app/presentations/pages/auth/sign_up/states/sign_up_state.dart';

import '../../../helper/utils.dart';
import '../../auth_mocks.dart';

void main() {
  late final repo = AuthRepositoryMock();
  late final authBloc = SignUpBloc(
    authRepository: repo,
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await S.delegate.load(const Locale('en'));
  });
  TABlocTest(
    description: 'SignUpBloc Tests',
    features: [
      TABlocTestFeature(
        description: 'SignUpBloc',
        scenarios: [
          SignUpFormValidateChangedSuccessScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignUpFormValidateChangedFailureScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignUpFormValidateChangedEmptyScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignUpFormValidateChangedEqualityScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignUpButtonPressedSuccessScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignUpButtonPressedFailureScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignUpButtonPressedEqualityScenario(
            repo: repo,
            authBloc: authBloc,
          ),
        ],
      ),
    ],
  ).test();
}

class SignUpFormValidateChangedSuccessScenario
    extends TABlocTestScenario<SignUpBloc, SignUpState> {
  SignUpFormValidateChangedSuccessScenario({
    required AuthRepositoryMock repo,
    required SignUpBloc authBloc,
  }) : super(
          description: '''
          Scenario: Test SignUpFormValidateChangedEvt Success
          Given a SignUpBloc instance
          When the SignUpFormValidateChangedEvt is added with valid data
          Then the state should reflect the updated form validation status and user input
        ''',
          setUp: () {
            when(() => repo.signUp(
                  emailOrPhoneNumber: any(named: 'emailOrPhoneNumber'),
                  password: any(named: 'password'),
                  username: any(named: 'username'),
                )).thenAnswer((_) async => AuthResponse());
          },
          build: () => authBloc,
          act: (bloc) => bloc.add(SignUpFormValidateChangedEvt(
            isValidate: true,
            username: 'username',
            emailOrPhoneNumber: 'emailOrPhoneNumber',
            password: 'password',
            confirmPassword: 'confirmPassword',
          )),
          expect: () => [
            SignUpState(
              status: const SignUpStatus.initial(),
              isFormValid: true,
              username: 'username',
              emailOrPhoneNumber: 'emailOrPhoneNumber',
              password: 'password',
              confirmPassword: 'confirmPassword',
            ),
          ],
        );
}

class SignUpFormValidateChangedFailureScenario
    extends TABlocTestScenario<SignUpBloc, SignUpState> {
  SignUpFormValidateChangedFailureScenario({
    required AuthRepositoryMock repo,
    required SignUpBloc authBloc,
  }) : super(
          description: '''
          Scenario: Test SignUpFormValidateChangedEvt Failure
          Given a SignUpBloc instance
          When the SignUpFormValidateChangedEvt is added with invalid data
          Then the state should reflect the updated form validation status and user input
        ''',
          setUp: () {
            when(() => repo.signUp(
                  emailOrPhoneNumber: any(named: 'emailOrPhoneNumber'),
                  password: any(named: 'password'),
                  username: any(named: 'username'),
                )).thenAnswer((_) async => AuthResponse());
          },
          build: () {
            return SignUpBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(SignUpFormValidateChangedEvt(
            isValidate: false,
            username: '',
            emailOrPhoneNumber: '',
            password: '',
            confirmPassword: '',
          )),
          expect: () => [
            SignUpState(
              status: const SignUpStatus.initial(),
              username: '',
              emailOrPhoneNumber: '',
              password: '',
              confirmPassword: '',
              isFormValid: false,
            ),
          ],
        );
}

class SignUpFormValidateChangedEmptyScenario
    extends TABlocTestScenario<SignUpBloc, SignUpState> {
  SignUpFormValidateChangedEmptyScenario({
    required AuthRepositoryMock repo,
    required SignUpBloc authBloc,
  }) : super(
          description: '''
      Scenario: Test SignUpFormValidateChangedEvt with empty fields
      Given a SignUpBloc instance
      When the SignUpFormValidateChangedEvt is added with empty fields
      Then the state should reflect the updated form validation status and user input
    ''',
          setUp: () {
            when(() => repo.signUp(
                  emailOrPhoneNumber: any(named: 'emailOrPhoneNumber'),
                  password: any(named: 'password'),
                  username: any(named: 'username'),
                )).thenAnswer((_) async => AuthResponse());
          },
          build: () {
            return SignUpBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(SignUpFormValidateChangedEvt(
            isValidate: false,
            username: '',
            emailOrPhoneNumber: '',
            password: '',
            confirmPassword: '',
          )),
          expect: () => [
            SignUpState(
              isFormValid: false,
              username: '',
              emailOrPhoneNumber: '',
              password: '',
              confirmPassword: '',
            ),
          ],
        );
}

class SignUpFormValidateChangedEqualityScenario
    extends TABlocTestScenario<SignUpBloc, SignUpState> {
  SignUpFormValidateChangedEqualityScenario({
    required AuthRepositoryMock repo,
    required SignUpBloc authBloc,
  }) : super(
          description: '''
      Scenario: Test SignUpFormValidateChangedEvt Equality
      Given a SignUpBloc instance
      When the SignUpFormValidateChangedEvt is added with valid data
      Then the state should reflect the updated form validation status and user input
    ''',
          setUp: () {
            when(() => repo.signUp(
                  emailOrPhoneNumber: any(named: 'emailOrPhoneNumber'),
                  password: any(named: 'password'),
                  username: any(named: 'username'),
                )).thenAnswer((_) async => AuthResponse());
          },
          build: () {
            return SignUpBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(SignUpFormValidateChangedEvt(
            isValidate: true,
            username: 'username',
            emailOrPhoneNumber: 'emailOrPhoneNumber',
            password: 'password',
            confirmPassword: 'confirmPassword',
          )),
          expect: () => [
            SignUpState(
              isFormValid: true,
              username: 'username',
              emailOrPhoneNumber: 'emailOrPhoneNumber',
              password: 'password',
              confirmPassword: 'confirmPassword',
            ),
          ],
        );
}

class SignUpButtonPressedSuccessScenario
    extends TABlocTestScenario<SignUpBloc, SignUpState> {
  SignUpButtonPressedSuccessScenario({
    required AuthRepositoryMock repo,
    required SignUpBloc authBloc,
  }) : super(
          description: '''
      Scenario: Test SignUpButtonPressedEvt Success
      Given a SignUpBloc instance
      When the SignUpButtonPressedEvt is added
      Then the state should reflect the loading status and then success
    ''',
          setUp: () {
            when(() => repo.signUp(
                  emailOrPhoneNumber: any(named: 'emailOrPhoneNumber'),
                  password: any(named: 'password'),
                  username: any(named: 'username'),
                )).thenAnswer(
              (_) async => AuthResponse(user: AuthMocks.user),
            );
          },
          build: () {
            return SignUpBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(SignUpButtonPressedEvt()),
        );
}

class SignUpButtonPressedEqualityScenario
    extends TABlocTestScenario<SignUpBloc, SignUpState> {
  SignUpButtonPressedEqualityScenario({
    required AuthRepositoryMock repo,
    required SignUpBloc authBloc,
  }) : super(
          description: '''
      Scenario: Test SignUpButtonPressedEvt Equality
      Given a SignUpBloc instance
      When the SignUpButtonPressedEvt is added
      Then the state should reflect the loading status and then success
    ''',
          setUp: () {
            when(() => repo.signUp(
                  emailOrPhoneNumber: any(named: 'emailOrPhoneNumber'),
                  password: any(named: 'password'),
                  username: any(named: 'username'),
                )).thenAnswer(
              (_) async => AuthResponse(user: AuthMocks.user),
            );
          },
          build: () {
            return SignUpBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(SignUpButtonPressedEvt()),
        );
}

class SignUpButtonPressedFailureScenario
    extends TABlocTestScenario<SignUpBloc, SignUpState> {
  SignUpButtonPressedFailureScenario({
    required AuthRepositoryMock repo,
    required SignUpBloc authBloc,
  }) : super(
          description: '''
      Scenario: Test SignUpButtonPressedEvt Failure
      Given a SignUpBloc instance
      When the SignUpButtonPressedEvt is added and the sign-up fails
      Then the state should reflect the failure status and error message
    ''',
          setUp: () {
            when(() => repo.signUp(
                  emailOrPhoneNumber: any(named: 'emailOrPhoneNumber'),
                  password: any(named: 'password'),
                  username: any(named: 'username'),
                )).thenThrow(Exception('Sign-up failed'));
          },
          build: () {
            return SignUpBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(SignUpButtonPressedEvt()),
        );
}
