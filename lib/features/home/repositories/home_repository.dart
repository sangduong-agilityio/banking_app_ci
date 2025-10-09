import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/setting/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// An abstract class that defines the methods for fetching home screen data.
abstract class HomeRepository {
  /// Fetches the current user's data.
  Future<UserModel?> fetchCurrentUser();

  /// Fetches the list of cards for the current user.
  Future<List<CardModel>> fetchCards();

  /// Fetches the list of accounts for the current user.
  Future<List<AccountModel>> fetchAccounts();
}

/// The implementation of [HomeRepository] that uses Supabase as the backend.
class HomeRepositoryImpl implements HomeRepository {
  final SupabaseClient _client;

  /// Creates a new instance of [HomeRepositoryImpl].
  HomeRepositoryImpl({required SupabaseClient client}) : _client = client;

  /// A utility to ensure the user is logged in.
  User get _currentUser {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user;
  }

  @override
  Future<UserModel?> fetchCurrentUser() async {
    final response = await _client
        .from('users')
        .select('username, email, profileImage')
        .eq('id', _currentUser.id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return UserModel.fromJson(response);
  }

  @override
  Future<List<CardModel>> fetchCards() async {
    final response = await _client
        .from('cards')
        .select()
        .eq('userId', _currentUser.id);

    return (response as List<dynamic>)
        .map((json) => CardModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<AccountModel>> fetchAccounts() async {
    final response = await _client
        .from('accounts')
        .select()
        .eq('userId', _currentUser.id);

    return (response as List)
        .map((json) => AccountModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
