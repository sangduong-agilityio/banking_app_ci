import 'package:banking_app/features/graphql_demo/domain/entities/comment_entity.dart';
import 'package:banking_app/features/graphql_demo/domain/entities/post_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'graphql_state.freezed.dart';

/// States for GraphQL demo feature
class GraphQLState extends Equatable {
  const GraphQLState({
    this.status = const GraphQLStatus.initial(),
    this.posts = const [],
    this.selectedPost,
    this.comments = const [],
    this.searchResults = const [],
    this.isSearching = false,
    this.errorMessage,
  });

  final GraphQLStatus status;
  final List<PostEntity> posts;
  final PostEntity? selectedPost;
  final List<CommentEntity> comments;
  final List<PostEntity> searchResults;
  final bool isSearching;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        posts,
        selectedPost,
        comments,
        searchResults,
        isSearching,
        errorMessage,
      ];

  GraphQLState copyWith({
    GraphQLStatus? status,
    List<PostEntity>? posts,
    PostEntity? selectedPost,
    List<CommentEntity>? comments,
    List<PostEntity>? searchResults,
    bool? isSearching,
    String? errorMessage,
  }) {
    return GraphQLState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      selectedPost: selectedPost ?? this.selectedPost,
      comments: comments ?? this.comments,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Status for GraphQL operations
@freezed
class GraphQLStatus with _$GraphQLStatus {
  const factory GraphQLStatus.initial() = _Initial;
  const factory GraphQLStatus.loading() = _Loading;
  const factory GraphQLStatus.success() = _Success;
  const factory GraphQLStatus.failure() = _Failure;
}
