import 'package:banking_app/core/data/services/graphql/graphql_client.dart';
import 'package:banking_app/core/data/services/graphql/users_queries.dart';
import 'package:banking_app/features/users/data/models/user_model.dart';
import 'package:banking_app/features/users/domain/entities/user_entity.dart';
import 'package:banking_app/features/users/domain/repositories/users_repository.dart';

/// ```
class UsersRepositoryImpl implements UsersRepository {
  final GraphQLClient _client;

  UsersRepositoryImpl({required GraphQLClient client}) : _client = client;

  @override
  Future<List<UserEntity>> getUsers() async {
    // Execute GraphQL query
    final result = await _client.query(query: UsersQueries.getUsers);

    final usersCollection = result['usersCollection'] as Map<String, dynamic>?;
    if (usersCollection == null) return [];

    final edges = usersCollection['edges'] as List<dynamic>? ?? [];

    return edges.map((edge) {
      final node = edge['node'] as Map<String, dynamic>;
      return UserModel.fromJson(node).toEntity();
    }).toList();
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    final result = await _client.query(
      query: UsersQueries.getUserById,
      variables: {'id': id},
    );

    final usersCollection = result['usersCollection'] as Map<String, dynamic>?;
    if (usersCollection == null) return null;

    final edges = usersCollection['edges'] as List<dynamic>? ?? [];
    if (edges.isEmpty) return null;

    final node = edges.first['node'] as Map<String, dynamic>;
    return UserModel.fromJson(node).toEntity();
  }

  @override
  Future<UserEntity> createUser({
    required String name,
    required String email,
    String? avatarUrl,
  }) async {
    // Execute GraphQL mutation
    final result = await _client.mutate(
      mutation: UsersQueries.createUser,
      variables: {
        'name': name,
        'email': email,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      },
    );

    // Parse mutation response
    // Response format: { "insertIntousersCollection": { "records": [...] } }
    final insertResult =
        result['insertIntousersCollection'] as Map<String, dynamic>;
    final records = insertResult['records'] as List<dynamic>;

    if (records.isEmpty) {
      throw Exception('Failed to create user');
    }

    // Map to entity
    final userJson = records.first as Map<String, dynamic>;
    return UserModel.fromJson(userJson).toEntity();
  }

  @override
  Future<UserEntity> updateUser({
    required String id,
    String? name,
    String? email,
  }) async {
    final result = await _client.mutate(
      mutation: UsersQueries.updateUser,
      variables: {
        'id': id,
        if (name != null) 'name': name,
        if (email != null) 'email': email,
      },
    );

    final updateResult =
        result['updateusersCollection'] as Map<String, dynamic>;
    final records = updateResult['records'] as List<dynamic>;

    if (records.isEmpty) {
      throw Exception('Failed to update user');
    }

    final userJson = records.first as Map<String, dynamic>;
    return UserModel.fromJson(userJson).toEntity();
  }

  @override
  Future<bool> deleteUser(String id) async {
    final result = await _client.mutate(
      mutation: UsersQueries.deleteUser,
      variables: {'id': id},
    );

    final deleteResult =
        result['deleteFromusersCollection'] as Map<String, dynamic>;
    final records = deleteResult['records'] as List<dynamic>;

    return records.isNotEmpty;
  }
}
