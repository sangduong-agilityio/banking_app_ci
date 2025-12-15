import 'package:banking_app/features/graphql_demo/domain/entities/post_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.g.dart';

/// Model representing a blog post in the GraphQL demo
@JsonSerializable()
class PostModel {
  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    this.published = false,
    this.commentsCount = 0,
    this.likesCount = 0,
  });

  final String id;
  final String title;
  final String body;
  final String userId;
  final bool published;
  final int commentsCount;
  final int likesCount;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  /// Convert model to entity
  PostEntity toEntity() {
    return PostEntity(
      id: id,
      title: title,
      body: body,
      userId: userId,
      published: published,
      commentsCount: commentsCount,
      likesCount: likesCount,
    );
  }

  /// Create model from entity
  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      userId: entity.userId,
      published: entity.published,
      commentsCount: entity.commentsCount,
      likesCount: entity.likesCount,
    );
  }

  PostModel copyWith({
    String? id,
    String? title,
    String? body,
    String? userId,
    bool? published,
    int? commentsCount,
    int? likesCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
      published: published ?? this.published,
      commentsCount: commentsCount ?? this.commentsCount,
      likesCount: likesCount ?? this.likesCount,
    );
  }
}
