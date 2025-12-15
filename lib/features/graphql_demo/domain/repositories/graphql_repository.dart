import 'package:banking_app/features/graphql_demo/domain/entities/comment_entity.dart';
import 'package:banking_app/features/graphql_demo/domain/entities/post_entity.dart';
import 'package:banking_app/features/graphql_demo/domain/entities/user_entity.dart';

/// Repository interface for GraphQL demo operations
abstract class GraphQLRepository {
  /// Query: Fetch all posts
  Future<List<PostEntity>> fetchPosts();

  /// Query: Fetch a single post by ID with comments
  Future<PostEntity> fetchPostById(String id);

  /// Query: Fetch comments for a post
  Future<List<CommentEntity>> fetchComments(String postId);

  /// Query: Fetch user by ID
  Future<UserEntity> fetchUserById(String id);

  /// Mutation: Create a new post
  Future<PostEntity> createPost({
    required String title,
    required String body,
    required String userId,
  });

  /// Mutation: Update a post
  Future<PostEntity> updatePost({
    required String id,
    String? title,
    String? body,
    bool? published,
  });

  /// Mutation: Delete a post
  Future<bool> deletePost(String id);

  /// Mutation: Add a comment to a post
  Future<CommentEntity> addComment({
    required String postId,
    required String userId,
    required String content,
  });

  /// Mutation: Like a post
  Future<PostEntity> likePost(String id);

  /// Query: Search posts by title
  Future<List<PostEntity>> searchPosts(String query);
}
