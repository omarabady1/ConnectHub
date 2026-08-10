import 'package:connect_hub/features/home/domain/entities/post_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    super.userId = '',
    required super.authorName,
    required super.authorRole,
    required super.timeAgo,
    super.avatarUrl,
    super.avatarInitial,
    super.isCurrentUser = false,
    required super.postTitle,
    required super.postContent,
    super.mainImageUrl,
    required super.likesCount,
    required super.commentsCount,
    super.isLiked = false,
    super.likedBy = const [],
  });

  PostModel copyWith({
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    List<String>? likedBy,
  }) {
    return PostModel(
      id: id,
      userId: userId,
      authorName: authorName,
      authorRole: authorRole,
      timeAgo: timeAgo,
      avatarUrl: avatarUrl,
      avatarInitial: avatarInitial,
      isCurrentUser: isCurrentUser,
      postTitle: postTitle,
      postContent: postContent,
      mainImageUrl: mainImageUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      likedBy: likedBy ?? this.likedBy,
    );
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    final createdAt = _stringValue(map['createdAt']);
    final postUserId = _stringValue(map['userId']);
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final likedByRaw = (map['likedBy'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return PostModel(
      id: _stringValue(map['id']),
      userId: postUserId,
      authorName: _stringValue(map['authorName'], fallback: 'Anonymous'),
      authorRole: _stringValue(map['authorRole'], fallback: 'Member'),
      timeAgo: _timeAgoFrom(createdAt),
      avatarUrl: _nullableStringValue(map['avatarUrl']),
      avatarInitial: _nullableStringValue(map['avatarInitial']),
      isCurrentUser:
          postUserId.isNotEmpty && postUserId == currentUid,
      postTitle: _stringValue(map['postTitle']),
      postContent: _stringValue(map['postContent']),
      mainImageUrl: _nullableStringValue(
        map['imageUrl'] ?? map['mainImageUrl'],
      ),
      likesCount: _intValue(map['likesCount']),
      commentsCount: _intValue(map['commentsCount']),
      likedBy: likedByRaw,
      isLiked: likedByRaw.contains(currentUid),
    );
  }

  Map<String, dynamic> toMap() {
    final createdAt = DateTime.now().toUtc().toIso8601String();

    return {
      'id': id,
      'userId': userId,
      'authorName': authorName,
      'authorRole': authorRole,
      'createdAt': createdAt,
      'avatarUrl': avatarUrl,
      'avatarInitial': avatarInitial,
      'postTitle': postTitle,
      'postContent': postContent,
      'imageUrl': mainImageUrl,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'likedBy': likedBy,
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
