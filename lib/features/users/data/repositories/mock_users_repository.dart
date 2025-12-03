import 'package:banking_app/features/users/domain/entities/user_entity.dart';
import 'package:banking_app/features/users/domain/repositories/users_repository.dart';

/// Mock implementation of UsersRepository for demo purposes
///
/// This simulates GraphQL responses without requiring a real server.
/// Use this to test the BLoC → UI flow.
class MockUsersRepository implements UsersRepository {
  // In-memory storage to simulate database
  final List<UserEntity> _users = [
    UserEntity(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    UserEntity(
      id: '2',
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    UserEntity(
      id: '3',
      name: 'Bob Wilson',
      email: 'bob.wilson@example.com',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  int _nextId = 4;

  @override
  Future<List<UserEntity>> getUsers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return a copy of the list
    return List.from(_users);
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserEntity> createUser({
    required String name,
    required String email,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final newUser = UserEntity(
      id: '${_nextId++}',
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      createdAt: DateTime.now(),
    );

    _users.add(newUser);
    return newUser;
  }

  @override
  Future<UserEntity> updateUser({
    required String id,
    String? name,
    String? email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _users.indexWhere((user) => user.id == id);
    if (index == -1) {
      throw Exception('User not found');
    }

    final oldUser = _users[index];
    final updatedUser = oldUser.copyWith(
      name: name ?? oldUser.name,
      email: email ?? oldUser.email,
    );

    _users[index] = updatedUser;
    return updatedUser;
  }

  @override
  Future<bool> deleteUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _users.indexWhere((user) => user.id == id);
    if (index == -1) {
      return false;
    }

    _users.removeAt(index);
    return true;
  }
}
