import 'package:banking_app/features/graphql_demo/domain/entities/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.g.dart';

/// Model representing a user in the GraphQL demo
@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
  });

  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? bio;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convert model to entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      bio: bio,
    );
  }

  /// Create model from entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatar: entity.avatar,
      bio: entity.bio,
    );
  }
}
