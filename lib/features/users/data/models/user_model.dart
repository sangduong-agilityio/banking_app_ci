import 'package:banking_app/features/users/domain/entities/user_entity.dart';

/// User data model for API responses
///
/// This model handles JSON serialization/deserialization
/// and maps to UserEntity for use in the domain layer.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  /// Convert to domain entity
  ///
  /// This is the mapping: GraphQL Response → UserModel → UserEntity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
    );
  }

  /// Create UserModel from domain entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email)';
}

/// Extension to parse list of users from GraphQL response
extension UserModelListExtension on List<dynamic> {
  /// Parse GraphQL edges response to list of UserModel
  ///
  /// GraphQL format:
  /// ```json
  /// {
  ///   "usersCollection": {
  ///     "edges": [
  ///       { "node": { "id": "...", "name": "...", ... } }
  ///     ]
  ///   }
  /// }
  /// ```
  List<UserModel> toUserModels() {
    return map((edge) {
      final node = edge['node'] as Map<String, dynamic>;
      return UserModel.fromJson(node);
    }).toList();
  }
}
