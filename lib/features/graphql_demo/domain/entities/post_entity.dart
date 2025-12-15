import 'package:equatable/equatable.dart';

/// Entity representing a blog post in the GraphQL demo
class PostEntity extends Equatable {
  const PostEntity({
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

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        userId,
        published,
        commentsCount,
        likesCount,
      ];

  PostEntity copyWith({
    String? id,
    String? title,
    String? body,
    String? userId,
    bool? published,
    int? commentsCount,
    int? likesCount,
  }) {
    return PostEntity(
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
