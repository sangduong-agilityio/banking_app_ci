import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  });
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });
  Future<void> forgotPassword(
    String email,
  );
  Future<void> resetPassword(
    String password,
  );

  Future<void> logout();
}

class AuthRepositoryImplement implements AuthRepository {
  final SupabaseClient _client;

  AuthRepositoryImplement(this._client);

  @override
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) =>
      _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) =>
      _client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

  @override
  Future<void> forgotPassword(String email) async =>
      await _client.auth.resetPasswordForEmail(email);

  @override
  Future<void> resetPassword(String password) async {
    final userAttributes = UserAttributes(password: password);
    await _client.auth.updateUser(userAttributes);
  }

  @override
  Future<void> logout() => _client.auth.signOut();
}
