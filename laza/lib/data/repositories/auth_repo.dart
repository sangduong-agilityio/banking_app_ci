import 'package:laza/data/models/user_model.dart';
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
  Future<Users?> fetchUserProfile();

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
  Future<Users?> fetchUserProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final userData = await _client
        .from('user')
        .select('id, userName, displayName, avatar, review')
        .eq('id', user.id)
        .single();

    return Users(
      id: userData['id'],
      userName: userData['userName'],
      displayName: userData['displayName'],
      avatar: userData['avatar'],
      review: userData['review'] ?? '',
    );
  }

  @override
  Future<void> logout() => _client.auth.signOut();
}
