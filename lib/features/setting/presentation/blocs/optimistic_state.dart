import 'package:banking_app/features/setting/data/models/post.dart';

enum OptimisticStatus { initial, loading, success, failure }

final class OptimisticState {
  const OptimisticState({
    this.posts = const [],
    this.previousPosts,
    this.pendingPostIds = const {},
    this.status = OptimisticStatus.initial,
    this.errorMessage,
  });

  final List<Post> posts; // Danh sách bài viết
  final List<Post>? previousPosts; // Backup để rollback nếu thất bại
  final Set<String> pendingPostIds; // IDs của posts đang pending reaction
  final OptimisticStatus status;
  final String? errorMessage;

  OptimisticState copyWith({
    List<Post>? posts,
    List<Post>? previousPosts,
    Set<String>? pendingPostIds,
    OptimisticStatus? status,
    String? errorMessage,
  }) {
    return OptimisticState(
      posts: posts ?? this.posts,
      previousPosts: previousPosts ?? this.previousPosts,
      pendingPostIds: pendingPostIds ?? this.pendingPostIds,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
