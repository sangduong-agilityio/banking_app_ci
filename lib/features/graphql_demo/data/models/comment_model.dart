import 'package:banking_app/features/graphql_demo/domain/entities/comment_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.g.dart';

/// Model representing a comment on a post in the GraphQL demo
@JsonSerializable()
class CommentModel {
  const CommentModel({
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

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  /// Convert model to entity
  CommentEntity toEntity() {
    return CommentEntity(
      id: id,
      postId: postId,
      userId: userId,
      userName: userName,
      content: content,
      createdAt: createdAt,
    );
  }

  /// Create model from entity
  factory CommentModel.fromEntity(CommentEntity entity) {
    return CommentModel(
      id: entity.id,
      postId: entity.postId,
      userId: entity.userId,
      userName: entity.userName,
      content: entity.content,
      createdAt: entity.createdAt,
    );
  }
}
