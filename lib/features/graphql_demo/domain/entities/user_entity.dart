import 'package:equatable/equatable.dart';

/// Entity representing a user in the GraphQL demo
class UserEntity extends Equatable {
  const UserEntity({
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

  @override
  List<Object?> get props => [id, name, email, avatar, bio];
}
