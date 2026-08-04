class PostModel {
  final String id;
  final String authorName;
  final String authorRole;
  final String timeAgo;
  final String? avatarUrl;
  final String? avatarInitial;
  final bool isCurrentUser;
  final String postTitle;
  final String postContent;
  final String? mainImageUrl;
  final List<String>? tags;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;

  const PostModel({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.timeAgo,
    this.avatarUrl,
    this.avatarInitial,
    this.isCurrentUser = false,
    required this.postTitle,
    required this.postContent,
    this.mainImageUrl,
    this.tags,
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false,
  });
}
