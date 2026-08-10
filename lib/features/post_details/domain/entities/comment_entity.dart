class CommentEntity {
  final String id;
  final String userId;
  final String authorName;
  final String? avatarUrl;
  final String? avatarInitial;
  final String content;
  final String createdAt;

  const CommentEntity({
    required this.id,
    this.userId = '',
    required this.authorName,
    this.avatarUrl,
    this.avatarInitial,
    required this.content,
    required this.createdAt,
  });

  String get timeAgo {
    final createdDate = DateTime.tryParse(createdAt);
    if (createdDate == null) return 'Just now';

    final diff = DateTime.now().toUtc().difference(createdDate);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${(diff.inDays / 7).floor()}w ago';
  }
}
