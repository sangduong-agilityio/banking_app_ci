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

  Session? getSession();

  User? getCurrentUser();

  Future<void> logout();
}

class AuthRepositoryImplement implements AuthRepository {
  final SupabaseClient _client;

  AuthRepositoryImplement({required SupabaseClient client}) : _client = client;

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final response = await _client.auth.signUp(
      email: email.contains('@') ? email : null,
      password: password,
      data: {'username': username},
    );

    final user = response.user;

    if (user != null) {
      await _client.from('users').insert({
        'id': user.id,
        'email': user.email,
        'username': username,
      });
    }

    return response;
  }

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

  @override
  Session? getSession() {
    return _client.auth.currentSession?.accessToken != null
        ? _client.auth.currentSession
        : null;
  }

  @override
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
