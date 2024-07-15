import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_repo.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository();

class AuthRepository {
  final _client = Supabase.instance.client;

  // This method signs in with the provided email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // This method signs up with the provided email, password, and username.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  // This method forgot password with the provided sent email
  Future<void> forgotPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // This method reset password with the provided password and confirm password
  Future<void> resetPassword(
    String password,
  ) async {
    final userAttributes = UserAttributes(
      password: password,
    );
    await _client.auth.updateUser(userAttributes);
  }

  // This method logout app
  Future<void> logout() => _client.auth.signOut();
}
