import 'dart:ui';

import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:banking_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../../helpers/utils.dart';
import '../mocks/auth_mocks.dart';

void main() {
  late AuthRepositoryMock repo;
  late BiometricServiceMock biometricService;
  late AuthBloc authBloc;
  late PrivateKeyMock prefs;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await S.delegate.load(const Locale('en'));
  });

  setUp(() {
    repo = AuthRepositoryMock();
    biometricService = BiometricServiceMock();
    prefs = PrivateKeyMock();
    authBloc = AuthBloc(
      repo: repo,
      biometricService: biometricService,
      prefs: prefs,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  BABlocTest(
    description: 'AuthBloc Tests',
    features: [
      /// SignIn Form Validation Tests
      BABlocTestFeature(
        description: 'SignIn Form Validation',
        scenarios: [
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignIn form validation with valid data
              Given a AuthBloc instance
              When SignInFormValidateChanged is added with valid credentials
              Then the state should reflect the updated form validation status
            ''',
            build: () => authBloc,
            act: (bloc) => bloc.add(
              SignInFormValidateChanged(
                isValidate: true,
                email: 'test@example.com',
                password: 'password123',
              ),
            ),
            expect: () => [
              AuthState(
                status: AuthStatus.initial,
                isFormValid: true,
                email: 'test@example.com',
                password: 'password123',
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignIn form validation with invalid data
              Given a AuthBloc instance
              When SignInFormValidateChanged is added with invalid data
              Then the state should reflect invalid form status
            ''',
            build: () => authBloc,
            act: (bloc) => bloc.add(
              SignInFormValidateChanged(
                isValidate: false,
                email: 'invalid',
                password: '123',
              ),
            ),
            expect: () => [
              AuthState(
                status: AuthStatus.initial,
                email: 'invalid',
                password: '123',
                isFormValid: false,
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignIn form validation with empty fields
              Given a AuthBloc instance
              When SignInFormValidateChanged is added with empty fields
              Then the state should reflect invalid form status
            ''',
            build: () => authBloc,
            act: (bloc) => bloc.add(
              SignInFormValidateChanged(
                isValidate: false,
                email: '',
                password: '',
              ),
            ),
            expect: () => [
              AuthState(
                status: AuthStatus.initial,
                isFormValid: false,
                email: '',
                password: '',
              ),
            ],
          ),
        ],
      ),

      /// SignIn Button Press Tests
      BABlocTestFeature(
        description: 'SignIn Button Press',
        scenarios: [
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignIn button pressed with valid credentials
              Given a AuthBloc with valid form data
              When SignInButtonPressed is added
              Then the authentication should succeed
            ''',
            setUp: () {
              when(
                () => repo.signIn(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                ),
              ).thenAnswer(
                (_) async => AuthResponse(
                  user: AuthMocks.user,
                  session: Session(
                    accessToken: 'test_token',
                    tokenType: 'bearer',
                    user: AuthMocks.user,
                  ),
                ),
              );
              when(
                () => prefs.setString(any(), any()),
              ).thenAnswer((_) async => true);
            },
            build: () => authBloc,
            seed: () => const AuthState(
              email: 'test@example.com',
              password: 'password123',
              isFormValid: true,
            ),
            act: (bloc) => bloc.add(SignInButtonPressed()),
            expect: () => [
              AuthState(
                status: AuthStatus.loading,
                email: 'test@example.com',
                password: 'password123',
                isFormValid: true,
                previousState: const AuthState(
                  email: 'test@example.com',
                  password: 'password123',
                  isFormValid: true,
                ),
                isOptimistic: true,
              ),
              AuthState(
                status: AuthStatus.success,
                email: 'test@example.com',
                password: 'password123',
                isFormValid: true,
                sessionToken: 'test_token',
                errorMessage: null,
              ),
            ],
            verify: (_) {
              verify(
                () => prefs.setString('session_token', 'test_token'),
              ).called(1);
            },
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignIn button pressed with authentication error
              Given a AuthBloc with valid form data
              When SignInButtonPressed is added and repo throws error
              Then the authentication should fail with error message
            ''',
            setUp: () {
              when(
                () => repo.signIn(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                ),
              ).thenThrow(Exception('Invalid credentials'));
            },
            build: () => authBloc,
            seed: () => const AuthState(
              email: 'test@example.com',
              password: 'wrong_password',
              isFormValid: true,
            ),
            act: (bloc) => bloc.add(SignInButtonPressed()),
            expect: () => [
              AuthState(
                status: AuthStatus.loading,
                email: 'test@example.com',
                password: 'wrong_password',
                isFormValid: true,
                previousState: const AuthState(
                  email: 'test@example.com',
                  password: 'wrong_password',
                  isFormValid: true,
                ),
                isOptimistic: true,
              ),
              AuthState(
                status: AuthStatus.failure,
                email: 'test@example.com',
                password: 'wrong_password',
                isFormValid: true,
                errorMessage:
                    'An unexpected error occurred. Please contact support if this persists.',
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignIn button pressed but no user returned
              Given a AuthBloc with valid form data
              When SignInButtonPressed is added but response has no user
              Then the authentication should fail
            ''',
            setUp: () {
              when(
                () => repo.signIn(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                ),
              ).thenAnswer((_) async => AuthMocks.authResponseNoUser);
            },
            build: () => authBloc,
            seed: () => const AuthState(
              email: 'test@example.com',
              password: 'password123',
              isFormValid: true,
            ),
            act: (bloc) => bloc.add(SignInButtonPressed()),
            expect: () => [
              AuthState(
                status: AuthStatus.loading,
                email: 'test@example.com',
                password: 'password123',
                isFormValid: true,
                previousState: const AuthState(
                  email: 'test@example.com',
                  password: 'password123',
                  isFormValid: true,
                ),
                isOptimistic: true,
              ),
              AuthState(
                status: AuthStatus.failure,
                email: 'test@example.com',
                password: 'password123',
                isFormValid: true,
                errorMessage: S.current.authErrorLoginFailed,
              ),
            ],
          ),
        ],
      ),

      /// SignUp Form Validation Tests
      BABlocTestFeature(
        description: 'SignUp Form Validation',
        scenarios: [
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignUp form validation with valid data
              Given a AuthBloc instance
              When SignUpFormValidateChanged is added with valid data
              Then the state should reflect the updated form validation status
            ''',
            build: () => authBloc,
            act: (bloc) => bloc.add(
              SignUpFormValidateChanged(
                isValidate: true,
                username: 'test_user',
                email: 'test@example.com',
                password: 'password123',
              ),
            ),
            expect: () => [
              AuthState(
                status: AuthStatus.initial,
                isFormValid: true,
                username: 'test_user',
                email: 'test@example.com',
                password: 'password123',
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignUp form validation with invalid data
              Given a AuthBloc instance
              When SignUpFormValidateChanged is added with invalid data
              Then the state should reflect invalid form status
            ''',
            build: () => authBloc,
            act: (bloc) => bloc.add(
              SignUpFormValidateChanged(
                isValidate: false,
                username: '',
                email: '',
                password: '',
              ),
            ),
            expect: () => [
              AuthState(
                status: AuthStatus.initial,
                isFormValid: false,
                username: '',
                email: '',
                password: '',
              ),
            ],
          ),
        ],
      ),

      /// SignUp Button Press Tests
      BABlocTestFeature(
        description: 'SignUp Button Press',
        scenarios: [
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignUp button pressed with valid data
              Given a AuthBloc with valid form data
              When SignUpButtonPressed is added
              Then the registration should succeed
            ''',
            setUp: () {
              when(
                () => repo.signUp(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                  username: any(named: 'username'),
                ),
              ).thenAnswer((_) async => AuthResponse(user: AuthMocks.user));
              when(
                () => repo.createUserProfile(
                  userId: any(named: 'userId'),
                  username: any(named: 'username'),
                  email: any(named: 'email'),
                ),
              ).thenAnswer((_) async => {});
            },
            build: () => authBloc,
            seed: () => const AuthState(
              username: 'test_user',
              email: 'test@example.com',
              password: 'password123',
              isFormValid: true,
              isTermsAccepted: true,
            ),
            act: (bloc) => bloc.add(SignUpButtonPressed()),
            expect: () => [
              AuthState(
                status: AuthStatus.loading,
                username: 'test_user',
                email: 'test@example.com',
                password: 'password123',
                isFormValid: true,
                isTermsAccepted: true,
                previousState: const AuthState(
                  username: 'test_user',
                  email: 'test@example.com',
                  password: 'password123',
                  isFormValid: true,
                  isTermsAccepted: true,
                ),
                isOptimistic: true,
              ),
              AuthState(
                status: AuthStatus.success,
                username: 'test_user',
                email: 'test@example.com',
                password: 'password123',
                isFormValid: true,
                isTermsAccepted: true,
                errorMessage: null,
              ),
            ],
            verify: (_) {
              verify(
                () => repo.createUserProfile(
                  userId: 'test_id',
                  username: 'test_user',
                  email: 'test@example.com',
                ),
              ).called(1);
            },
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignUp button pressed with error
              Given a AuthBloc with valid form data
              When SignUpButtonPressed is added and repo throws error
              Then the registration should fail
            ''',
            setUp: () {
              when(
                () => repo.signUp(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                  username: any(named: 'username'),
                ),
              ).thenThrow(Exception('Email already exists'));
            },
            build: () => authBloc,
            seed: () => const AuthState(
              username: 'test_user',
              email: 'existing@example.com',
              password: 'password123',
              isFormValid: true,
            ),
            act: (bloc) => bloc.add(SignUpButtonPressed()),
            expect: () => [
              AuthState(
                status: AuthStatus.loading,
                username: 'test_user',
                email: 'existing@example.com',
                password: 'password123',
                isFormValid: true,
                previousState: const AuthState(
                  username: 'test_user',
                  email: 'existing@example.com',
                  password: 'password123',
                  isFormValid: true,
                ),
                isOptimistic: true,
              ),
              AuthState(
                status: AuthStatus.failure,
                username: 'test_user',
                email: 'existing@example.com',
                password: 'password123',
                isFormValid: true,
                errorMessage:
                    'An unexpected error occurred. Please contact support if this persists.',
              ),
            ],
          ),
        ],
      ),

      /// SignUp Terms Changed Tests
      BABlocTestFeature(
        description: 'SignUp Terms Changed',
        scenarios: [
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignUp terms acceptance changed
              Given a AuthBloc instance
              When SignUpTermsChanged is added
              Then the state should reflect the terms acceptance status
            ''',
            build: () => authBloc,
            act: (bloc) => bloc.add(SignUpTermsChanged(isAccepted: true)),
            expect: () => [
              const AuthState(
                status: AuthStatus.initial,
                isTermsAccepted: true,
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignUp terms unacceptance changed
              Given a AuthBloc instance
              When SignUpTermsChanged is added with false
              Then the state should reflect the terms unacceptance status
            ''',
            build: () => authBloc,
            act: (bloc) => bloc.add(SignUpTermsChanged(isAccepted: false)),
            expect: () => [
              const AuthState(
                status: AuthStatus.initial,
                isTermsAccepted: false,
              ),
            ],
          ),
        ],
      ),

      /// Biometric Authentication Tests
      BABlocTestFeature(
        description: 'Biometric Authentication',
        scenarios: [
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: Check biometric availability successfully
              Given a device with biometric capabilities
              When CheckBiometricAvailability is added
              Then the state should reflect biometric availability
            ''',
            setUp: () {
              when(
                () => biometricService.canCheckBiometrics(),
              ).thenAnswer((_) async => true);
              when(
                () => biometricService.isBiometricEnabled(),
              ).thenAnswer((_) async => true);
              when(
                () => biometricService.getRefreshToken(),
              ).thenAnswer((_) async => 'refresh_token');
            },
            build: () => authBloc,
            act: (bloc) => bloc.add(CheckBiometricAvailability()),
            expect: () => [
              const AuthState(
                status: AuthStatus.initial,
                isBiometricAvailable: true,
                isBiometricEnabled: true,
                hasSavedBiometricCredentials: true,
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: Check biometric availability - device supports but not enabled
              Given a device with biometric capabilities but not enabled
              When CheckBiometricAvailability is added
              Then the state should reflect biometric not enabled
            ''',
            setUp: () {
              when(
                () => biometricService.canCheckBiometrics(),
              ).thenAnswer((_) async => true);
              when(
                () => biometricService.isBiometricEnabled(),
              ).thenAnswer((_) async => false);
              when(
                () => biometricService.getRefreshToken(),
              ).thenAnswer((_) async => null);
            },
            build: () => authBloc,
            act: (bloc) => bloc.add(CheckBiometricAvailability()),
            expect: () => [
              const AuthState(
                status: AuthStatus.initial,
                isBiometricAvailable: true,
                isBiometricEnabled: false,
                hasSavedBiometricCredentials: false,
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: Check biometric availability with error
              Given a biometric service that throws error
              When CheckBiometricAvailability is added
              Then the state should show biometric as unavailable
            ''',
            setUp: () {
              when(
                () => biometricService.canCheckBiometrics(),
              ).thenThrow(Exception('Biometric not supported'));
            },
            build: () => authBloc,
            act: (bloc) => bloc.add(CheckBiometricAvailability()),
            expect: () => [
              const AuthState(
                status: AuthStatus.initial,
                isBiometricAvailable: false,
                isBiometricEnabled: false,
                hasSavedBiometricCredentials: false,
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignIn with biometric successfully
              Given a user with biometric enabled
              When SignInWithBiometric is added
              Then the authentication should succeed
            ''',
            setUp: () {
              when(
                () => biometricService.canLoginWithBiometrics(),
              ).thenAnswer((_) async => true);
              when(
                () => biometricService.loginWithBiometrics(),
              ).thenAnswer((_) async => 'refresh_token');
              when(() => repo.setSession(any())).thenAnswer(
                (_) async => AuthResponse(
                  user: AuthMocks.user,
                  session: Session(
                    accessToken: 'test_token',
                    tokenType: 'bearer',
                    user: AuthMocks.user,
                  ),
                ),
              );
            },
            build: () => authBloc,
            act: (bloc) => bloc.add(SignInWithBiometric()),
            expect: () => [
              AuthState(
                status: AuthStatus.loading,
                previousState: const AuthState(),
                isOptimistic: true,
              ),
              AuthState(
                status: AuthStatus.failure,
                errorMessage: S.current.authErrorUnknown,
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignIn with biometric not enabled
              Given biometric is not enabled
              When SignInWithBiometric is added
              Then the authentication should fail with appropriate message
            ''',
            setUp: () {
              when(
                () => biometricService.canLoginWithBiometrics(),
              ).thenAnswer((_) async => false);
            },
            build: () => authBloc,
            act: (bloc) => bloc.add(SignInWithBiometric()),
            expect: () => [
              AuthState(
                status: AuthStatus.loading,
                previousState: const AuthState(),
                isOptimistic: true,
              ),
              AuthState(
                status: AuthStatus.failure,
                errorMessage: S.current.authErrorBiometricNotEnabled,
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignIn with biometric returns no token
              Given biometric authentication fails to return token
              When SignInWithBiometric is added
              Then the authentication should fail
            ''',
            setUp: () {
              when(
                () => biometricService.canLoginWithBiometrics(),
              ).thenAnswer((_) async => true);
              when(
                () => biometricService.loginWithBiometrics(),
              ).thenAnswer((_) async => null);
            },
            build: () => authBloc,
            act: (bloc) => bloc.add(SignInWithBiometric()),
            expect: () => [
              AuthState(
                status: AuthStatus.loading,
                previousState: const AuthState(),
                isOptimistic: true,
              ),
              AuthState(
                status: AuthStatus.failure,
                errorMessage: S.current.authErrorBiometricFailed,
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignIn with biometric throws error
              Given biometric service throws error
              When SignInWithBiometric is added
              Then the authentication should fail with unknown error
            ''',
            setUp: () {
              when(
                () => biometricService.canLoginWithBiometrics(),
              ).thenThrow(Exception('Biometric error'));
            },
            build: () => authBloc,
            act: (bloc) => bloc.add(SignInWithBiometric()),
            expect: () => [
              AuthState(
                status: AuthStatus.loading,
                previousState: const AuthState(),
                isOptimistic: true,
              ),
              AuthState(
                status: AuthStatus.failure,
                errorMessage: S.current.authErrorUnknown,
              ),
            ],
          ),
          BABlocTestScenario<AuthBloc, AuthState>(
            description: '''
              Scenario: SignIn with Touch ID successfully
              Given a user with Touch ID enabled
              When SignInWithBiometric is added
              Then the authentication should succeed
            ''',
            setUp: () {
              when(
                () => biometricService.canLoginWithBiometrics(),
              ).thenAnswer((_) async => true);
              when(
                () => biometricService.hasTouchId(),
              ).thenAnswer((_) async => true);
              when(
                () => biometricService.loginWithBiometrics(),
              ).thenAnswer((_) async => 'refresh_token');
              when(() => repo.setSession(any())).thenAnswer(
                (_) async => AuthResponse(
                  user: AuthMocks.user,
                  session: Session(
                    accessToken: 'test_token',
                    tokenType: 'bearer',
                    user: AuthMocks.user,
                  ),
                ),
              );
              when(
                () => prefs.setString(any(), any()),
              ).thenAnswer((_) async => true);
            },
            build: () => authBloc,
            act: (bloc) => bloc.add(SignInWithBiometric()),
            expect: () => [
              AuthState(
                status: AuthStatus.loading,
                previousState: const AuthState(),
                isOptimistic: true,
              ),
              AuthState(
                status: AuthStatus.success,
                sessionToken: 'test_token',
                errorMessage: null,
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
