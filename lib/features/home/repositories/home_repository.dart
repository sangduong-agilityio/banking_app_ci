import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/setting/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class HomeRepository {
  Future<UserModel?> fetchCurrentUser();
  Future<List<CardModel>> fetchCards();
  Future<List<AccountModel>> fetchAccounts();
}

class HomeRepositoryImpl implements HomeRepository {
  final SupabaseClient _client;

  HomeRepositoryImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<UserModel?> fetchCurrentUser() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) return null;

    final response = await _client
        .from('users')
        .select('username, email, profileImage')
        .eq('id', currentUser.id)
        .maybeSingle();

    return UserModel(
      username: response?['username'] ?? '',
      email: response?['email'] ?? currentUser.email ?? '',
      phoneNumber: currentUser.phone ?? '',
      profileImage: response?['profileImage'] ?? '',
    );
  }

  @override
  Future<List<CardModel>> fetchCards() async {
    final currentUser = _client.auth.currentUser;

    final response = await _client
        .from('cards')
        .select()
        .eq('user_id', currentUser?.id ?? 0);

    return (response as List<dynamic>)
        .map((json) => CardModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<AccountModel>> fetchAccounts() async {
    final currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw Exception('User is not logged in');
    }

    final response = await _client
        .from('accounts')
        .select()
        .eq('user_id', currentUser.id);
    return (response as List)
        .map((json) => AccountModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
