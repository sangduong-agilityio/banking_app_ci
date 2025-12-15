import 'package:banking_app/features/graphql_demo/data/models/comment_model.dart';
import 'package:banking_app/features/graphql_demo/data/models/post_model.dart';
import 'package:banking_app/features/graphql_demo/data/models/user_model.dart';

/// Mock GraphQL data source with realistic social media content
class GraphQLDataSource {
  // Mock users - Social media influencers and content creators
  static final _users = <String, UserModel>{
    '1': const UserModel(
      id: '1',
      name: 'Sarah Johnson',
      email: 'sarah.j@social.app',
      avatar: 'https://i.pravatar.cc/150?img=1',
      bio: '📸 Travel Blogger | 🌍 Digital Nomad | ✈️ Visited 50+ countries',
    ),
    '2': const UserModel(
      id: '2',
      name: 'Mike Chen',
      email: 'mike.chen@social.app',
      avatar: 'https://i.pravatar.cc/150?img=12',
      bio: '🍳 Food Enthusiast | 👨‍🍳 Recipe Creator | 📺 Cooking Show Host',
    ),
    '3': const UserModel(
      id: '3',
      name: 'Emma Davis',
      email: 'emma.d@social.app',
      avatar: 'https://i.pravatar.cc/150?img=5',
      bio: '💪 Fitness Coach | 🏋️ Personal Trainer | 🥗 Healthy Lifestyle',
    ),
    '4': const UserModel(
      id: '4',
      name: 'Alex Martinez',
      email: 'alex.m@social.app',
      avatar: 'https://i.pravatar.cc/150?img=8',
      bio: '🎮 Gaming Streamer | 🎯 Esports Player | 🏆 Tournament Winner',
    ),
    '5': const UserModel(
      id: '5',
      name: 'Lisa Wong',
      email: 'lisa.w@social.app',
      avatar: 'https://i.pravatar.cc/150?img=9',
      bio: '💄 Beauty Guru | ✨ Makeup Artist | 👗 Fashion Enthusiast',
    ),
  };

  // Mock posts - Realistic social media content
  static final _posts = <String, PostModel>{
    '1': const PostModel(
      id: '1',
      title: 'Hidden Gems in Bali 🌴',
      body:
          'Just discovered the most amazing waterfall in Ubud! The locals barely know about this place. Crystal clear water, peaceful atmosphere, and absolutely breathtaking views. Who else loves finding off-the-beaten-path locations? 🗺️✨\n\n#BaliTravel #HiddenGems #TravelTips',
      userId: '1',
      published: true,
      commentsCount: 15,
      likesCount: 234,
    ),
    '2': const PostModel(
      id: '2',
      title: '10-Minute Pasta Carbonara Recipe 🍝',
      body:
          'Quick dinner recipe alert! This authentic Italian carbonara is ready in just 10 minutes. No cream needed - just eggs, pecorino, guanciale, and pasta. Creamy, delicious, and SO easy! Recipe in comments 👇\n\n#QuickRecipes #ItalianFood #Foodie',
      userId: '2',
      published: true,
      commentsCount: 42,
      likesCount: 567,
    ),
    '3': const PostModel(
      id: '3',
      title: 'My 30-Day Fitness Transformation 💪',
      body:
          'Started my fitness journey 30 days ago and the results are incredible! Lost 5kg, gained muscle, and feeling more energetic than ever. Remember: consistency is key! No magic pills, just hard work and dedication.\n\n#FitnessJourney #Transformation #HealthyLifestyle',
      userId: '3',
      published: true,
      commentsCount: 28,
      likesCount: 891,
    ),
    '4': const PostModel(
      id: '4',
      title: 'Epic Gaming Session - New World Record! 🎮',
      body:
          'WE DID IT! Just set a new speedrun world record in Dark Souls 3! 🏆 Hours of practice finally paid off. Thanks to everyone who joined the stream! Full run highlights coming soon.\n\n#Gaming #Speedrun #WorldRecord',
      userId: '4',
      published: true,
      commentsCount: 93,
      likesCount: 1247,
    ),
    '5': const PostModel(
      id: '5',
      title: 'Summer Makeup Trends 2025 ✨',
      body:
          'Here are the TOP 5 makeup trends you need to try this summer! 💄 Dewy skin is BACK, bold lips are making a comeback, and glossy lids are everywhere. Which trend is your favorite?\n\n#MakeupTrends #BeautyTips #SummerLooks',
      userId: '5',
      published: true,
      commentsCount: 67,
      likesCount: 723,
    ),
    '6': const PostModel(
      id: '6',
      title: 'Working From a Beach in Thailand 🏖️',
      body:
          'Living the digital nomad dream! Currently working from a beachfront cafe in Koh Samui. The WiFi is surprisingly good and the coconut smoothies are even better. Is this real life? 😍\n\n#DigitalNomad #RemoteWork #Thailand',
      userId: '1',
      published: false,
      commentsCount: 0,
      likesCount: 0,
    ),
  };

  // Mock comments - Realistic social media interactions
  static final _comments = <String, List<CommentModel>>{
    '1': [
      CommentModel(
        id: '1',
        postId: '1',
        userId: '2',
        userName: 'Mike Chen',
        content: 'This looks amazing! Can you share the exact location? 🙏',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      CommentModel(
        id: '2',
        postId: '1',
        userId: '3',
        userName: 'Emma Davis',
        content: 'Adding this to my Bali itinerary! Thanks for sharing! 📝',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      CommentModel(
        id: '3',
        postId: '1',
        userId: '1',
        userName: 'Sarah Johnson',
        content: 'DMed you the coordinates! It\'s near Tegalalang 😊',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
    '2': [
      CommentModel(
        id: '4',
        postId: '2',
        userId: '1',
        userName: 'Sarah Johnson',
        content: 'Making this tonight! Looks delicious 🤤',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      CommentModel(
        id: '5',
        postId: '2',
        userId: '5',
        userName: 'Lisa Wong',
        content: 'Where do you buy guanciale? Can I use bacon instead?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
    '3': [
      CommentModel(
        id: '6',
        postId: '3',
        userId: '4',
        userName: 'Alex Martinez',
        content: 'Inspiring! What was your workout routine?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
    ],
    '4': [
      CommentModel(
        id: '7',
        postId: '4',
        userId: '3',
        userName: 'Emma Davis',
        content: 'INSANE!!! Watched the whole stream, you\'re a legend! 🔥',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ],
    '5': [
      CommentModel(
        id: '8',
        postId: '5',
        userId: '2',
        userName: 'Mike Chen',
        content: 'My girlfriend loves your makeup tutorials! 💕',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ],
  };

  int _postIdCounter = 7;
  int _commentIdCounter = 9;

  /// Query: Fetch all posts
  Future<List<PostModel>> fetchPosts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _posts.values.toList();
  }

  /// Query: Fetch a single post by ID
  Future<PostModel?> fetchPostById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _posts[id];
  }

  /// Query: Fetch comments for a post
  Future<List<CommentModel>> fetchComments(String postId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _comments[postId] ?? [];
  }

  /// Query: Fetch user by ID
  Future<UserModel?> fetchUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _users[id];
  }

  /// Mutation: Create a new post
  Future<PostModel> createPost({
    required String title,
    required String body,
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final newPost = PostModel(
      id: (_postIdCounter++).toString(),
      title: title,
      body: body,
      userId: userId,
      published: false,
      commentsCount: 0,
      likesCount: 0,
    );

    _posts[newPost.id] = newPost;
    return newPost;
  }

  /// Mutation: Update a post
  Future<PostModel> updatePost({
    required String id,
    String? title,
    String? body,
    bool? published,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final post = _posts[id];
    if (post == null) {
      throw Exception('Post not found');
    }

    final updatedPost = post.copyWith(
      title: title,
      body: body,
      published: published,
    );

    _posts[id] = updatedPost;
    return updatedPost;
  }

  /// Mutation: Delete a post
  Future<bool> deletePost(String id) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _posts.remove(id);
    _comments.remove(id);
    return true;
  }

  /// Mutation: Add a comment to a post
  Future<CommentModel> addComment({
    required String postId,
    required String userId,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final user = _users[userId];
    if (user == null) {
      throw Exception('User not found');
    }

    final post = _posts[postId];
    if (post == null) {
      throw Exception('Post not found');
    }

    final newComment = CommentModel(
      id: (_commentIdCounter++).toString(),
      postId: postId,
      userId: userId,
      userName: user.name,
      content: content,
      createdAt: DateTime.now(),
    );

    _comments.putIfAbsent(postId, () => []).add(newComment);

    // Update post comment count
    final updatedPost = post.copyWith(
      commentsCount: post.commentsCount + 1,
    );
    _posts[postId] = updatedPost;

    return newComment;
  }

  /// Mutation: Like a post
  Future<PostModel> likePost(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final post = _posts[id];
    if (post == null) {
      throw Exception('Post not found');
    }

    final updatedPost = post.copyWith(
      likesCount: post.likesCount + 1,
    );

    _posts[id] = updatedPost;
    return updatedPost;
  }

  /// Query: Search posts by title
  Future<List<PostModel>> searchPosts(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return _posts.values
        .where(
          (post) =>
              post.title.toLowerCase().contains(query.toLowerCase()) ||
              post.body.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
