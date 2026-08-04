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
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    final createdAt = _stringValue(map['createdAt']);

    return PostModel(
      id: _stringValue(map['id']),
      authorName: _stringValue(map['authorName'], fallback: 'Anonymous'),
      authorRole: _stringValue(map['authorRole'], fallback: 'Member'),
      timeAgo: _timeAgoFrom(createdAt),
      avatarUrl: _nullableStringValue(map['avatarUrl']),
      avatarInitial: _nullableStringValue(map['avatarInitial']),
      isCurrentUser: _boolValue(map['isCurrentUser']),
      postTitle: _stringValue(map['postTitle']),
      postContent: _stringValue(map['postContent']),
      mainImageUrl: _nullableStringValue(
        map['imageUrl'] ?? map['mainImageUrl'],
      ),
      likesCount: _intValue(map['likesCount']),
      commentsCount: _intValue(map['commentsCount']),
      isLiked: _boolValue(map['isLiked']),
    );
  }

  Map<String, dynamic> toMap() {
    final createdAt = DateTime.now().toUtc().toIso8601String();

    return {
      'id': id,
      'authorName': authorName,
      'authorRole': authorRole,
      'createdAt': createdAt,
      'avatarUrl': avatarUrl,
      'avatarInitial': avatarInitial,
      'isCurrentUser': isCurrentUser,
      'postTitle': postTitle,
      'postContent': postContent,
      'imageUrl': mainImageUrl,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
    };
  }

  static String _stringValue(Object? value, {String fallback = ''}) {
    if (value is String && value.isNotEmpty) return value;
    return fallback;
  }

  static String? _nullableStringValue(Object? value) {
    if (value is String && value.isNotEmpty) return value;
    return null;
  }

  static int _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _boolValue(Object? value) => value is bool && value;

  static String _timeAgoFrom(String createdAt) {
    final createdDate = DateTime.tryParse(createdAt);
    if (createdDate == null) return 'Just now';

    final difference = DateTime.now().toUtc().difference(createdDate);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';

    return '${(difference.inDays / 7).floor()}w';
  }
}
