import 'package:supabase_flutter/supabase_flutter.dart';

/// Abstract class defining the contract for an AuthRepository.
/// Any authentication repository should implement this interface.
abstract class AuthRepository {
  /// Sign up a new user with email, password, and username.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  });

  /// Sign in an existing user using email and password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });

  /// Refresh the current session to get a new access token.
  Future<AuthResponse> refreshSession();

  /// Set the session using a refresh token.
  /// Typically used when restoring session on app startup.
  Future<AuthResponse> setSession(String refreshToken);

  /// Get the current user if logged in.
  User? getCurrentUser();

  /// Log out the current user.
  Future<void> logout();
}

/// Concrete implementation of AuthRepository using Supabase.
class AuthRepositoryImplement implements AuthRepository {
  final SupabaseClient _client;

  /// Constructor takes a SupabaseClient instance from outside (dependency injection).
  AuthRepositoryImplement({required SupabaseClient client}) : _client = client;

  /// Sign up a new user with Supabase.
  /// Stores additional metadata like username in `data`.
  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  /// Sign in using email and password.
  @override
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Refresh the session and return a new AuthResponse.
  @override
  Future<AuthResponse> refreshSession() async {
    return await _client.auth.refreshSession();
  }

  /// Set the session manually using a refresh token.
  /// Useful for restoring user session after app restart.
  @override
  Future<AuthResponse> setSession(String refreshToken) async {
    return await _client.auth.setSession(refreshToken);
  }

  /// Return the current logged-in user, if any.
  @override
  User? getCurrentUser() => _client.auth.currentUser;

  /// Sign out the current user.
  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
