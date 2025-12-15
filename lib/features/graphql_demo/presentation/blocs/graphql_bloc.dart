import 'package:banking_app/core/common/bloc/base_bloc.dart';
import 'package:banking_app/features/graphql_demo/domain/repositories/graphql_repository.dart';
import 'package:banking_app/features/graphql_demo/presentation/blocs/graphql_event.dart';
import 'package:banking_app/features/graphql_demo/presentation/blocs/graphql_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC for managing GraphQL demo operations
class GraphQLBloc extends BaseBloc<GraphQLEvent, GraphQLState> {
  GraphQLBloc({required this.repository}) : super(const GraphQLState()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<FetchPostDetailsEvent>(_onFetchPostDetails);
    on<CreatePostEvent>(_onCreatePost);
    on<UpdatePostEvent>(_onUpdatePost);
    on<DeletePostEvent>(_onDeletePost);
    on<AddCommentEvent>(_onAddComment);
    on<LikePostEvent>(_onLikePost);
    on<SearchPostsEvent>(_onSearchPosts);
    on<ClearSearchEvent>(_onClearSearch);
  }

  final GraphQLRepository repository;

  /// Handle fetching all posts (Query example)
  Future<void> _onFetchPosts(
    FetchPostsEvent event,
    Emitter<GraphQLState> emit,
  ) async {
    emit(state.copyWith(status: const GraphQLStatus.loading()));

    try {
      final posts = await repository.fetchPosts();

      emit(
        state.copyWith(
          status: const GraphQLStatus.success(),
          posts: posts,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const GraphQLStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Handle fetching post details with comments (Nested Query example)
  Future<void> _onFetchPostDetails(
    FetchPostDetailsEvent event,
    Emitter<GraphQLState> emit,
  ) async {
    emit(state.copyWith(status: const GraphQLStatus.loading()));

    try {
      final post = await repository.fetchPostById(event.postId);
      final comments = await repository.fetchComments(event.postId);

      emit(
        state.copyWith(
          status: const GraphQLStatus.success(),
          selectedPost: post,
          comments: comments,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const GraphQLStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Handle creating a new post (Mutation example)
  Future<void> _onCreatePost(
    CreatePostEvent event,
    Emitter<GraphQLState> emit,
  ) async {
    emit(state.copyWith(status: const GraphQLStatus.loading()));

    try {
      final newPost = await repository.createPost(
        title: event.title,
        body: event.body,
        userId: event.userId,
      );

      // Update posts list with new post
      final updatedPosts = [newPost, ...state.posts];

      emit(
        state.copyWith(
          status: const GraphQLStatus.success(),
          posts: updatedPosts,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const GraphQLStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Handle updating a post (Mutation example)
  Future<void> _onUpdatePost(
    UpdatePostEvent event,
    Emitter<GraphQLState> emit,
  ) async {
    emit(state.copyWith(status: const GraphQLStatus.loading()));

    try {
      final updatedPost = await repository.updatePost(
        id: event.id,
        title: event.title,
        body: event.body,
        published: event.published,
      );

      // Update posts list
      final updatedPosts = state.posts.map((post) {
        return post.id == updatedPost.id ? updatedPost : post;
      }).toList();

      emit(
        state.copyWith(
          status: const GraphQLStatus.success(),
          posts: updatedPosts,
          selectedPost: state.selectedPost?.id == updatedPost.id
              ? updatedPost
              : state.selectedPost,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const GraphQLStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Handle deleting a post (Mutation example)
  Future<void> _onDeletePost(
    DeletePostEvent event,
    Emitter<GraphQLState> emit,
  ) async {
    emit(state.copyWith(status: const GraphQLStatus.loading()));

    try {
      await repository.deletePost(event.id);

      // Remove post from list
      final updatedPosts =
          state.posts.where((post) => post.id != event.id).toList();

      emit(
        state.copyWith(
          status: const GraphQLStatus.success(),
          posts: updatedPosts,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const GraphQLStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Handle adding a comment (Mutation example)
  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<GraphQLState> emit,
  ) async {
    emit(state.copyWith(status: const GraphQLStatus.loading()));

    try {
      final newComment = await repository.addComment(
        postId: event.postId,
        userId: event.userId,
        content: event.content,
      );

      // Update comments list
      final updatedComments = [...state.comments, newComment];

      // Update post comment count
      final updatedPosts = state.posts.map((post) {
        if (post.id == event.postId) {
          return post.copyWith(commentsCount: post.commentsCount + 1);
        }
        return post;
      }).toList();

      emit(
        state.copyWith(
          status: const GraphQLStatus.success(),
          comments: updatedComments,
          posts: updatedPosts,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const GraphQLStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Handle liking a post (Mutation example)
  Future<void> _onLikePost(
    LikePostEvent event,
    Emitter<GraphQLState> emit,
  ) async {
    try {
      final updatedPost = await repository.likePost(event.postId);

      // Optimistically update UI
      final updatedPosts = state.posts.map((post) {
        return post.id == updatedPost.id ? updatedPost : post;
      }).toList();

      emit(
        state.copyWith(
          posts: updatedPosts,
          selectedPost: state.selectedPost?.id == updatedPost.id
              ? updatedPost
              : state.selectedPost,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const GraphQLStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Handle searching posts (Query with variables example)
  Future<void> _onSearchPosts(
    SearchPostsEvent event,
    Emitter<GraphQLState> emit,
  ) async {
    emit(state.copyWith(isSearching: true));

    try {
      final results = await repository.searchPosts(event.query);

      emit(
        state.copyWith(
          searchResults: results,
          isSearching: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSearching: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Handle clearing search
  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<GraphQLState> emit,
  ) async {
    emit(
      state.copyWith(
        searchResults: [],
        isSearching: false,
      ),
    );
  }
}
