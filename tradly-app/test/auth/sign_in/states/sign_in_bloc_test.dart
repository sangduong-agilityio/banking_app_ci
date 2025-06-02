import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/features/auth/states/sign_in_bloc.dart';
import 'package:tradly_app/features/auth/states/sign_in_event.dart';
import 'package:tradly_app/features/auth/states/sign_in_state.dart';

import '../../../helper/utils.dart';
import '../../auth_mocks.dart';

void main() {
  late final repo = AuthRepositoryMock();
  late final authBloc = SignInBloc(
    authRepository: repo,
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await S.delegate.load(const Locale('en'));
  });
  TABlocTest(
    description: 'SignBloc Tests',
    features: [
      TABlocTestFeature(
        description: 'SignBloc',
        scenarios: [
          SignInFormValidateChangedSuccessScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignInFormValidateChangedFailureScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignInFormValidateChangedEmptyScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignInFormValidateChangedEqualityScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignInButtonPressedSuccessScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignInButtonPressedFailureScenario(
            repo: repo,
            authBloc: authBloc,
          ),
          SignInButtonPressedEqualityScenario(
            repo: repo,
            authBloc: authBloc,
          ),
        ],
      ),
    ],
  ).test();
}

class SignInFormValidateChangedSuccessScenario
    extends TABlocTestScenario<SignInBloc, SignInState> {
  SignInFormValidateChangedSuccessScenario({
    required AuthRepositoryMock repo,
    required SignInBloc authBloc,
  }) : super(
          description: '''
          Scenario: Test SignInFormValidateChangedEvt Success
          Given a SignInBloc instance
          When the SignInFormValidateChangedEvt is added with valid data
          Then the state should reflect the updated form validation status and user input
        ''',
          setUp: () {
            when(() => repo.signIn(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                )).thenAnswer((_) async => AuthResponse());
          },
          build: () => authBloc,
          act: (bloc) => bloc.add(SignInFormValidateChangedEvt(
            isValidate: true,
            email: 'email',
            password: 'password',
          )),
          expect: () => [
            SignInState(
              status: const SignInStatus.initial(),
              isFormValid: true,
              email: 'email',
              password: 'password',
            ),
          ],
        );
}

class SignInFormValidateChangedFailureScenario
    extends TABlocTestScenario<SignInBloc, SignInState> {
  SignInFormValidateChangedFailureScenario({
    required AuthRepositoryMock repo,
    required SignInBloc authBloc,
  }) : super(
          description: '''
          Scenario: Test SignInFormValidateChangedEvt Failure
          Given a SignInBloc instance
          When the SignInFormValidateChangedEvt is added with invalid data
          Then the state should reflect the updated form validation status and user input
        ''',
          setUp: () {
            when(() => repo.signIn(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                )).thenAnswer((_) async => AuthResponse());
          },
          build: () {
            return SignInBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(SignInFormValidateChangedEvt(
            isValidate: false,
            email: '',
            password: '',
          )),
          expect: () => [
            SignInState(
              status: const SignInStatus.initial(),
              email: '',
              password: '',
              isFormValid: false,
            ),
          ],
        );
}

class SignInFormValidateChangedEmptyScenario
    extends TABlocTestScenario<SignInBloc, SignInState> {
  SignInFormValidateChangedEmptyScenario({
    required AuthRepositoryMock repo,
    required SignInBloc authBloc,
  }) : super(
          description: '''
      Scenario: Test SignInFormValidateChangedEvt with empty fields
      Given a SignInBloc instance
      When the SignInFormValidateChangedEvt is added with empty fields
      Then the state should reflect the updated form validation status and user input
    ''',
          setUp: () {
            when(() => repo.signIn(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                )).thenAnswer((_) async => AuthResponse());
          },
          build: () {
            return SignInBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(
            SignInFormValidateChangedEvt(
              isValidate: false,
              email: '',
              password: '',
            ),
          ),
          expect: () => [
            SignInState(
              isFormValid: false,
              email: '',
              password: '',
            ),
          ],
        );
}

class SignInFormValidateChangedEqualityScenario
    extends TABlocTestScenario<SignInBloc, SignInState> {
  SignInFormValidateChangedEqualityScenario({
    required AuthRepositoryMock repo,
    required SignInBloc authBloc,
  }) : super(
          description: '''
      Scenario: Test SignInFormValidateChangedEvt Equality
      Given a SignInBloc instance
      When the SignInFormValidateChangedEvt is added with valid data
      Then the state should reflect the updated form validation status and user input
    ''',
          setUp: () {
            when(() => repo.signIn(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                )).thenAnswer((_) async => AuthResponse());
          },
          build: () {
            return SignInBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(SignInFormValidateChangedEvt(
            isValidate: true,
            email: 'email',
            password: 'password',
          )),
          expect: () => [
            SignInState(
              isFormValid: true,
              email: 'email',
              password: 'password',
            ),
          ],
        );
}

class SignInButtonPressedSuccessScenario
    extends TABlocTestScenario<SignInBloc, SignInState> {
  SignInButtonPressedSuccessScenario({
    required AuthRepositoryMock repo,
    required SignInBloc authBloc,
  }) : super(
          description: '''
      Scenario: Test SignInButtonPressedEvt Success
      Given a SignInBloc instance
      When the SignInButtonPressedEvt is added
      Then the state should reflect the loading status and then success
    ''',
          setUp: () {
            when(() => repo.signIn(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                )).thenAnswer(
              (_) async => AuthResponse(user: AuthMocks.user),
            );
          },
          build: () {
            return SignInBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(SignInButtonPressedEvt()),
        );
}

class SignInButtonPressedEqualityScenario
    extends TABlocTestScenario<SignInBloc, SignInState> {
  SignInButtonPressedEqualityScenario({
    required AuthRepositoryMock repo,
    required SignInBloc authBloc,
  }) : super(
          description: '''
      Scenario: Test SignInButtonPressedEvt Equality
      Given a SignInBloc instance
      When the SignInButtonPressedEvt is added
      Then the state should reflect the loading status and then success
    ''',
          setUp: () {
            when(() => repo.signIn(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                )).thenAnswer(
              (_) async => AuthResponse(user: AuthMocks.user),
            );
          },
          build: () {
            return SignInBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(SignInButtonPressedEvt()),
        );
}

class SignInButtonPressedFailureScenario
    extends TABlocTestScenario<SignInBloc, SignInState> {
  SignInButtonPressedFailureScenario({
    required AuthRepositoryMock repo,
    required SignInBloc authBloc,
  }) : super(
          description: '''
      Scenario: Test SignInButtonPressedEvt Failure
      Given a SignInBloc instance
      When the SignInButtonPressedEvt is added and the sign-in fails
      Then the state should reflect the failure status and error message
    ''',
          setUp: () {
            when(() => repo.signIn(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                )).thenThrow(Exception('Sign-in failed'));
          },
          build: () {
            return SignInBloc(
              authRepository: repo,
            );
          },
          act: (bloc) => bloc.add(SignInButtonPressedEvt()),
        );
}
