import 'package:banking_app/features/setting/data/models/post.dart';

/// Mock data for demo posts
class MockPosts {
  /// Generate initial posts for optimistic UI demo
  static List<Post> generateInitialPosts() {
    return [
      // POST 1: Always SUCCESS (hidden behavior)
      Post(
        id: '1',
        author: 'John Smith',
        content:
            'Beautiful sunset at the beach today 🌅 Sometimes you just need to take a moment and appreciate the little things in life.',
        imageUrl: 'https://picsum.photos/seed/success1/1200/900',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likeCount: 42,
        commentCount: 8,
        shareCount: 3,
        userReaction: null,
      ),
      // POST 2: Always FAIL (hidden behavior)
      Post(
        id: '2',
        author: 'Sarah Johnson',
        content:
            'Excited to announce that I just finished my first marathon! 🏃‍♀️ 26.2 miles of pure determination. Thank you to everyone who supported me along the way!',
        imageUrl: 'https://picsum.photos/seed/fail2/1200/900',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likeCount: 156,
        commentCount: 23,
        shareCount: 12,
        userReaction: null,
      ),
      // POST 3: Random behavior - Natural post
      Post(
        id: '3',
        author: 'Mike Chen',
        content:
            'Just had the most amazing coffee at this new café downtown ☕️ Their latte art is incredible! Highly recommend checking it out if you\'re in the area.',
        imageUrl: 'https://picsum.photos/seed/coffee3/1200/900',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        likeCount: 89,
        commentCount: 12,
        shareCount: 5,
        userReaction: null,
      ),
      // POST 4: Random behavior - Natural post
      Post(
        id: '4',
        author: 'Emma Wilson',
        content:
            'Finally finished this book I\'ve been reading for weeks! 📚 The ending was absolutely mind-blowing. No spoilers, but if you love sci-fi, you need to read this!',
        imageUrl: 'https://picsum.photos/seed/book4/1200/900',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        likeCount: 234,
        commentCount: 34,
        shareCount: 18,
        userReaction: null,
      ),
    ];
  }
}
