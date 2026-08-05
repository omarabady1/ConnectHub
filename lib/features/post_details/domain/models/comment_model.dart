class CommentModel {
  final String id;
  final String userId;
  final String authorName;
  final String? avatarUrl;
  final String? avatarInitial;
  final String content;
  final String createdAt;

  const CommentModel({
    required this.id,
    this.userId = '',
    required this.authorName,
    this.avatarUrl,
    this.avatarInitial,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: _stringValue(map['id']),
      userId: _stringValue(map['userId']),
      authorName: _stringValue(
        map['authorName'],
        fallback: 'Anonymous',
      ),
      avatarUrl: _nullableStringValue(map['avatarUrl']),
      avatarInitial: _nullableStringValue(map['avatarInitial']),
      content: _stringValue(map['content']),
      createdAt: _stringValue(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'authorName': authorName,
      'avatarUrl': avatarUrl,
      'avatarInitial': avatarInitial,
      'content': content,
      'createdAt': createdAt,
    };
  }

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

  static String _stringValue(Object? value, {String fallback = ''}) {
    if (value is String && value.isNotEmpty) return value;
    return fallback;
  }

  static String? _nullableStringValue(Object? value) {
    if (value is String && value.isNotEmpty) return value;
    return null;
  }
}