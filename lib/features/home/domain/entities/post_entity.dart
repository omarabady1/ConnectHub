class PostEntity {
  final String id;
  final String userId;
  final String authorName;
  final String authorRole;
  final String timeAgo;
  final String? avatarUrl;
  final String? avatarInitial;
  final bool isCurrentUser;
  final String postTitle;
  final String postContent;
  final String? mainImageUrl;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final List<String> likedBy;

  const PostEntity({
    required this.id,
    this.userId = '',
    required this.authorName,
    required this.authorRole,
    required this.timeAgo,
    this.avatarUrl,
    this.avatarInitial,
    this.isCurrentUser = false,
    required this.postTitle,
    required this.postContent,
    this.mainImageUrl,
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false,
    this.likedBy = const [],
  });
}
