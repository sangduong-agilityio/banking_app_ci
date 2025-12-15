/// Model cho social media post
class Post {
  const Post({
    required this.id,
    required this.author,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.userReaction,
  });

  final String id;
  final String author;
  final String content;
  final String imageUrl;
  final DateTime timestamp;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final ReactionType? userReaction;

  Post copyWith({
    String? id,
    String? author,
    String? content,
    String? imageUrl,
    DateTime? timestamp,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    ReactionType? userReaction,
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      userReaction: userReaction ?? this.userReaction,
    );
  }
}

enum ReactionType {
  like,
  love,
  haha,
  wow,
  sad,
  angry;

  String get emoji {
    switch (this) {
      case ReactionType.like:
        return '👍';
      case ReactionType.love:
        return '❤️';
      case ReactionType.haha:
        return '😄';
      case ReactionType.wow:
        return '😮';
      case ReactionType.sad:
        return '😢';
      case ReactionType.angry:
        return '😠';
    }
  }

  String get label {
    switch (this) {
      case ReactionType.like:
        return 'Like';
      case ReactionType.love:
        return 'Love';
      case ReactionType.haha:
        return 'Haha';
      case ReactionType.wow:
        return 'Wow';
      case ReactionType.sad:
        return 'Sad';
      case ReactionType.angry:
        return 'Angry';
    }
  }
}
