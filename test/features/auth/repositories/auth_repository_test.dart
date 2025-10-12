import 'package:banking_app/features/auth/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../helpers/utils.dart';

// Mock Supabase classes - extends Mock and implements the real interface
class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockUser extends Mock implements User {}

class MockSession extends Mock implements Session {}

void main() {
  late MockSupabaseClient mockClient;
  late MockGoTrueClient mockAuth;
  late AuthRepositoryImplement repository;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(() => mockClient.auth).thenReturn(mockAuth);
    repository = AuthRepositoryImplement(client: mockClient);
  });
  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(() => mockClient.auth).thenReturn(mockAuth);
    repository = AuthRepositoryImplement(client: mockClient);
  });

  BAUnitTest(
    description: 'AuthRepository Tests',
    features: [
      BAUTFeature(
        description: 'Sign Up',
        scenarios: [
          BAUTScenario(
            description:
                'successfully signs up new user with email, password, and username',
            when: () {
              final mockResponse = MockAuthResponse();
              final mockUser = MockUser();

              when(() => mockUser.id).thenReturn('user-123');
              when(() => mockUser.email).thenReturn('test@example.com');
              when(
                () => mockUser.userMetadata,
              ).thenReturn({'username': 'testuser'});
              when(() => mockResponse.user).thenReturn(mockUser);

              when(
                () => mockAuth.signUp(
                  email: 'test@example.com',
                  password: 'password123',
                  data: {'username': 'testuser'},
                ),
              ).thenAnswer((_) async => mockResponse);

              return mockResponse;
            },
            act: (_) async {
              return await repository.signUp(
                email: 'test@example.com',
                password: 'password123',
                username: 'testuser',
              );
            },
            expect: (result) {
              expect(result, isA<AuthResponse>());
              expect(result.user, isNotNull);
              expect(result.user?.id, 'user-123');
              expect(result.user?.email, 'test@example.com');
              expect(result.user?.userMetadata?['username'], 'testuser');

              verify(
                () => mockAuth.signUp(
                  email: 'test@example.com',
                  password: 'password123',
                  data: {'username': 'testuser'},
                ),
              ).called(1);
            },
          ),
          BAUTScenario(
            description: 'throws exception when sign up fails',
            when: () {
              when(
                () => mockAuth.signUp(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                  data: any(named: 'data'),
                ),
              ).thenThrow(Exception('Email already exists'));

              return Exception('Email already exists');
            },
            act: (_) async {
              try {
                await repository.signUp(
                  email: 'existing@example.com',
                  password: 'password123',
                  username: 'testuser',
                );
                return null;
              } catch (e) {
                return e;
              }
            },
            expect: (result) {
              expect(result, isA<Exception>());
              expect(result.toString(), contains('Email already exists'));
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'Sign In',
        scenarios: [
          BAUTScenario(
            description: 'successfully signs in user with valid credentials',
            when: () {
              final mockResponse = MockAuthResponse();
              final mockUser = MockUser();
              final mockSession = MockSession();

              when(() => mockUser.id).thenReturn('user-123');
              when(() => mockUser.email).thenReturn('test@example.com');
              when(
                () => mockSession.accessToken,
              ).thenReturn('access-token-123');
              when(
                () => mockSession.refreshToken,
              ).thenReturn('refresh-token-123');
              when(() => mockResponse.user).thenReturn(mockUser);
              when(() => mockResponse.session).thenReturn(mockSession);

              when(
                () => mockAuth.signInWithPassword(
                  email: 'test@example.com',
                  password: 'password123',
                ),
              ).thenAnswer((_) async => mockResponse);

              return mockResponse;
            },
            act: (_) async {
              return await repository.signIn(
                email: 'test@example.com',
                password: 'password123',
              );
            },
            expect: (result) {
              expect(result, isA<AuthResponse>());
              expect(result.user, isNotNull);
              expect(result.session, isNotNull);
              expect(result.user?.id, 'user-123');
              expect(result.session?.accessToken, 'access-token-123');

              verify(
                () => mockAuth.signInWithPassword(
                  email: 'test@example.com',
                  password: 'password123',
                ),
              ).called(1);
            },
          ),
          BAUTScenario(
            description: 'throws exception with invalid credentials',
            when: () {
              when(
                () => mockAuth.signInWithPassword(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                ),
              ).thenThrow(Exception('Invalid credentials'));

              return Exception('Invalid credentials');
            },
            act: (_) async {
              try {
                await repository.signIn(
                  email: 'wrong@example.com',
                  password: 'wrongpassword',
                );
                return null;
              } catch (e) {
                return e;
              }
            },
            expect: (result) {
              expect(result, isA<Exception>());
              expect(result.toString(), contains('Invalid credentials'));
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'Session Management',
        scenarios: [
          BAUTScenario(
            description: 'successfully refreshes session',
            when: () {
              final mockResponse = MockAuthResponse();
              final mockSession = MockSession();

              when(
                () => mockSession.accessToken,
              ).thenReturn('new-access-token');
              when(
                () => mockSession.refreshToken,
              ).thenReturn('new-refresh-token');
              when(() => mockResponse.session).thenReturn(mockSession);

              when(
                () => mockAuth.refreshSession(),
              ).thenAnswer((_) async => mockResponse);

              return mockResponse;
            },
            act: (_) async {
              return await repository.refreshSession();
            },
            expect: (result) {
              expect(result, isA<AuthResponse>());
              expect(result.session, isNotNull);
              expect(result.session?.accessToken, 'new-access-token');
              verify(() => mockAuth.refreshSession()).called(1);
            },
          ),
          BAUTScenario(
            description: 'successfully sets session with refresh token',
            when: () {
              final mockResponse = MockAuthResponse();
              final mockUser = MockUser();
              final mockSession = MockSession();

              when(() => mockUser.id).thenReturn('user-123');
              when(
                () => mockSession.accessToken,
              ).thenReturn('restored-access-token');
              when(() => mockResponse.user).thenReturn(mockUser);
              when(() => mockResponse.session).thenReturn(mockSession);

              when(
                () => mockAuth.setSession('stored-refresh-token'),
              ).thenAnswer((_) async => mockResponse);

              return mockResponse;
            },
            act: (_) async {
              return await repository.setSession('stored-refresh-token');
            },
            expect: (result) {
              expect(result, isA<AuthResponse>());
              expect(result.user, isNotNull);
              expect(result.session, isNotNull);
              expect(result.user?.id, 'user-123');
              verify(
                () => mockAuth.setSession('stored-refresh-token'),
              ).called(1);
            },
          ),
          BAUTScenario(
            description: 'throws exception when refresh token is invalid',
            when: () {
              when(
                () => mockAuth.setSession(any()),
              ).thenThrow(Exception('Invalid refresh token'));

              return Exception('Invalid refresh token');
            },
            act: (_) async {
              try {
                await repository.setSession('invalid-token');
                return null;
              } catch (e) {
                return e;
              }
            },
            expect: (result) {
              expect(result, isA<Exception>());
              expect(result.toString(), contains('Invalid refresh token'));
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'Get Current User',
        scenarios: [
          BAUTScenario(
            description: 'returns current user when logged in',
            when: () {
              final mockUser = MockUser();
              when(() => mockUser.id).thenReturn('user-123');
              when(() => mockUser.email).thenReturn('test@example.com');
              when(() => mockAuth.currentUser).thenReturn(mockUser);

              return mockUser;
            },
            act: (_) {
              return repository.getCurrentUser();
            },
            expect: (result) {
              expect(result, isNotNull);
              expect(result, isA<User>());
              expect(result?.id, 'user-123');
              expect(result?.email, 'test@example.com');
              verify(() => mockAuth.currentUser).called(1);
            },
          ),
          BAUTScenario(
            description: 'returns null when not logged in',
            when: () {
              when(() => mockAuth.currentUser).thenReturn(null);
              return null;
            },
            act: (_) {
              return repository.getCurrentUser();
            },
            expect: (result) {
              expect(result, isNull);
              verify(() => mockAuth.currentUser).called(1);
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'Logout',
        scenarios: [
          BAUTScenario(
            description: 'successfully logs out user',
            when: () {
              when(() => mockAuth.signOut()).thenAnswer((_) async {});
              return true;
            },
            act: (_) async {
              await repository.logout();
              return true;
            },
            expect: (result) {
              expect(result, true);
              verify(() => mockAuth.signOut()).called(1);
            },
          ),
          BAUTScenario(
            description: 'throws exception when logout fails',
            when: () {
              when(
                () => mockAuth.signOut(),
              ).thenThrow(Exception('Logout failed'));
              return Exception('Logout failed');
            },
            act: (_) async {
              try {
                await repository.logout();
                return null;
              } catch (e) {
                return e;
              }
            },
            expect: (result) {
              expect(result, isA<Exception>());
              expect(result.toString(), contains('Logout failed'));
            },
          ),
        ],
      ),
    ],
  ).test();
}
