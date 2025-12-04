import 'package:banking_app/features/users/domain/entities/user_entity.dart';

abstract class UsersRepository {
  Future<List<UserEntity>> getUsers();
  Future<UserEntity?> getUserById(String id);

  Future<UserEntity> createUser({
    required String name,
    required String email,
    String? avatarUrl,
  });

  Future<UserEntity> updateUser({
    required String id,
    String? name,
    String? email,
  });

  Future<bool> deleteUser(String id);
}
