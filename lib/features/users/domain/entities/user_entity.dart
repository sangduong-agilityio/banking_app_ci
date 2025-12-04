import 'package:equatable/equatable.dart';

/// User entity representing a user in the domain layer
///
/// This is the domain model used throughout the application.
/// It's mapped from UserModel (data layer) to be used in BLoC and UI.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.createdAt,
  });

  /// Create a copy with modified fields
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatarUrl, createdAt];

  @override
  String toString() => 'UserEntity(id: $id, name: $name, email: $email)';
}
