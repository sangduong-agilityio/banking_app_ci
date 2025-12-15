import 'package:equatable/equatable.dart';

/// Events for GraphQL demo feature
abstract class GraphQLEvent extends Equatable {
  const GraphQLEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize and fetch all posts
class FetchPostsEvent extends GraphQLEvent {
  const FetchPostsEvent();
}

/// Event to fetch a single post with details
class FetchPostDetailsEvent extends GraphQLEvent {
  const FetchPostDetailsEvent(this.postId);

  final String postId;

  @override
  List<Object?> get props => [postId];
}

/// Event to create a new post
class CreatePostEvent extends GraphQLEvent {
  const CreatePostEvent({
    required this.title,
    required this.body,
    required this.userId,
  });

  final String title;
  final String body;
  final String userId;

  @override
  List<Object?> get props => [title, body, userId];
}

/// Event to update an existing post
class UpdatePostEvent extends GraphQLEvent {
  const UpdatePostEvent({
    required this.id,
    this.title,
    this.body,
    this.published,
  });

  final String id;
  final String? title;
  final String? body;
  final bool? published;

  @override
  List<Object?> get props => [id, title, body, published];
}

/// Event to delete a post
class DeletePostEvent extends GraphQLEvent {
  const DeletePostEvent(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to add a comment to a post
class AddCommentEvent extends GraphQLEvent {
  const AddCommentEvent({
    required this.postId,
    required this.userId,
    required this.content,
  });

  final String postId;
  final String userId;
  final String content;

  @override
  List<Object?> get props => [postId, userId, content];
}

/// Event to like a post
class LikePostEvent extends GraphQLEvent {
  const LikePostEvent(this.postId);

  final String postId;

  @override
  List<Object?> get props => [postId];
}

/// Event to search posts
class SearchPostsEvent extends GraphQLEvent {
  const SearchPostsEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to clear search results
class ClearSearchEvent extends GraphQLEvent {
  const ClearSearchEvent();
}
