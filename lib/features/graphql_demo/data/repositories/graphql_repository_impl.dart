import 'package:banking_app/features/graphql_demo/data/datasources/graphql_data_source.dart';
import 'package:banking_app/features/graphql_demo/domain/entities/comment_entity.dart';
import 'package:banking_app/features/graphql_demo/domain/entities/post_entity.dart';
import 'package:banking_app/features/graphql_demo/domain/entities/user_entity.dart';
import 'package:banking_app/features/graphql_demo/domain/repositories/graphql_repository.dart';

/// Implementation of GraphQL repository
class GraphQLRepositoryImpl implements GraphQLRepository {
  GraphQLRepositoryImpl({required this.dataSource});

  final GraphQLDataSource dataSource;

  @override
  Future<List<PostEntity>> fetchPosts() async {
    final posts = await dataSource.fetchPosts();
    return posts.map((p) => p.toEntity()).toList();
  }

  @override
  Future<PostEntity> fetchPostById(String id) async {
    final post = await dataSource.fetchPostById(id);
    if (post == null) {
      throw Exception('Post not found');
    }
    return post.toEntity();
  }

  @override
  Future<List<CommentEntity>> fetchComments(String postId) async {
    final comments = await dataSource.fetchComments(postId);
    return comments.map((c) => c.toEntity()).toList();
  }

  @override
  Future<UserEntity> fetchUserById(String id) async {
    final user = await dataSource.fetchUserById(id);
    if (user == null) {
      throw Exception('User not found');
    }
    return user.toEntity();
  }

  @override
  Future<PostEntity> createPost({
    required String title,
    required String body,
    required String userId,
  }) async {
    final post = await dataSource.createPost(
      title: title,
      body: body,
      userId: userId,
    );
    return post.toEntity();
  }

  @override
  Future<PostEntity> updatePost({
    required String id,
    String? title,
    String? body,
    bool? published,
  }) async {
    final post = await dataSource.updatePost(
      id: id,
      title: title,
      body: body,
      published: published,
    );
    return post.toEntity();
  }

  @override
  Future<bool> deletePost(String id) async {
    return await dataSource.deletePost(id);
  }

  @override
  Future<CommentEntity> addComment({
    required String postId,
    required String userId,
    required String content,
  }) async {
    final comment = await dataSource.addComment(
      postId: postId,
      userId: userId,
      content: content,
    );
    return comment.toEntity();
  }

  @override
  Future<PostEntity> likePost(String id) async {
    final post = await dataSource.likePost(id);
    return post.toEntity();
  }

  @override
  Future<List<PostEntity>> searchPosts(String query) async {
    final posts = await dataSource.searchPosts(query);
    return posts.map((p) => p.toEntity()).toList();
  }
}
