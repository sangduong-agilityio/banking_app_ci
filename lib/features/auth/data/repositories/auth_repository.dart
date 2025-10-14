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

  /// Create a new user profile.
  Future<void> createUserProfile({
    required String userId,
    required String username,
    required String email,
  });
}

/// Concrete implementation of [AuthRepository] using Supabase.
class AuthRepositoryImplement implements AuthRepository {
  final SupabaseClient _client;

  /// Creates an [AuthRepositoryImplement] object.
  ///
  /// The [client] is the Supabase client used to make authentication requests.
  AuthRepositoryImplement({required SupabaseClient client}) : _client = client;

  /// Signs up a new user with Supabase.
  ///
  /// This method implements the [signUp] method from the [AuthRepository] class.
  /// It stores additional metadata like username in the `data` field.
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

  /// Signs in an existing user with Supabase.
  ///
  /// This method implements the [signIn] method from the [AuthRepository] class.
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

  /// Refreshes the current session to get a new access token.
  ///
  /// This method implements the [refreshSession] method from the [AuthRepository] class.
  @override
  Future<AuthResponse> refreshSession() async {
    return await _client.auth.refreshSession();
  }

  /// Sets the session using a refresh token.
  ///
  /// This method implements the [setSession] method from the [AuthRepository] class.
  /// It is typically used when restoring the session on app startup.
  @override
  Future<AuthResponse> setSession(String refreshToken) async {
    return await _client.auth.setSession(refreshToken);
  }

  /// Gets the current user if logged in.
  ///
  /// This method implements the [getCurrentUser] method from the [AuthRepository] class.
  @override
  User? getCurrentUser() => _client.auth.currentUser;

  /// Logs out the current user.
  ///
  /// This method implements the [logout] method from the [AuthRepository] class.
  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  @override
  Future<void> createUserProfile({
    required String userId,
    required String username,
    required String email,
  }) async {
    await _client.from('users').insert({
      'id': userId,
      'username': username,
      'email': email,
    });
  }
}
