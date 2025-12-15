import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/setting/data/models/post.dart';
import 'package:banking_app/features/setting/data/models/mock_posts.dart';
import 'package:banking_app/features/setting/presentation/blocs/optimistic_state.dart';

class OptimisticCubit extends Cubit<OptimisticState> {
  OptimisticCubit()
    : super(OptimisticState(posts: MockPosts.generateInitialPosts()));

  /// Toggle reaction for a post with optimistic update
  Future<void> toggleReaction(
    String postId,
    ReactionType? newReaction, {
    bool? forceSuccess,
  }) async {
    // Find the post
    final postIndex = state.posts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;

    final post = state.posts[postIndex];
    final previousReaction = post.userReaction;

    // Calculate new like count
    int newLikeCount = post.likeCount;
    if (previousReaction != null && newReaction == null) {
      // Remove reaction
      newLikeCount = post.likeCount - 1;
    } else if (previousReaction == null && newReaction != null) {
      // Add reaction
      newLikeCount = post.likeCount + 1;
    }
    // If only changing reaction, keep count unchanged

    // Backup current state for rollback if needed
    final previousPosts = List<Post>.from(state.posts);

    // Optimistic update: Update UI immediately
    final updatedPost = post.copyWith(
      userReaction: newReaction,
      likeCount: newLikeCount,
    );

    final updatedPosts = List<Post>.from(state.posts);
    updatedPosts[postIndex] = updatedPost;

    // Add post ID to pending set
    final pendingIds = Set<String>.from(state.pendingPostIds)..add(postId);

    emit(
      state.copyWith(
        posts: updatedPosts,
        previousPosts: previousPosts,
        pendingPostIds: pendingIds,
        status: OptimisticStatus.loading,
      ),
    );

    // Simulate API call (1-2 seconds)
    await Future.delayed(
      Duration(milliseconds: 1000 + (DateTime.now().millisecond % 1000)),
    );

    // Determine success or failure based on post ID
    final isSuccess = postId == '1'
        ? true // Post 1: Always SUCCESS
        : postId == '2'
        ? false // Post 2: Always FAIL
        : (forceSuccess ?? (DateTime.now().millisecond % 10 < 7));

    // Remove post ID from pending set
    final newPendingIds = Set<String>.from(state.pendingPostIds)
      ..remove(postId);

    if (isSuccess) {
      // API succeeded: Confirm the change
      emit(
        state.copyWith(
          pendingPostIds: newPendingIds,
          status: OptimisticStatus.success,
          errorMessage: null,
        ),
      );
    } else {
      // API failed: Rollback to previous state
      final failureReasons = [
        'Network connection lost',
        'Server temporarily unavailable',
        'Rate limit exceeded',
        'Invalid request',
        'Post no longer available',
      ];

      final reason =
          failureReasons[DateTime.now().microsecond % failureReasons.length];

      emit(
        state.copyWith(
          posts: previousPosts,
          pendingPostIds: newPendingIds,
          status: OptimisticStatus.failure,
          errorMessage:
              'Reaction failed: $reason\n\nYour action has been reverted.',
        ),
      );
    }
  }

  /// Reset to initial state
  void reset() {
    emit(OptimisticState(posts: MockPosts.generateInitialPosts()));
  }

  /// Clear error message
  void clearError() {
    emit(state.copyWith(errorMessage: null, status: OptimisticStatus.initial));
  }
}
