import 'package:equatable/equatable.dart';

/// Entity representing a comment on a post in the GraphQL demo
class CommentEntity extends Equatable {
  const CommentEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        postId,
        userId,
        userName,
        content,
        createdAt,
      ];
}
