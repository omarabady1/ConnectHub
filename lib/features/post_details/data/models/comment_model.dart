import 'package:connect_hub/features/post_details/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    super.userId = '',
    required super.authorName,
    super.avatarUrl,
    super.avatarInitial,
    required super.content,
    required super.createdAt,
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

  static String _stringValue(Object? value, {String fallback = ''}) {
    if (value is String && value.isNotEmpty) return value;
    return fallback;
  }

  static String? _nullableStringValue(Object? value) {
    if (value is String && value.isNotEmpty) return value;
    return null;
  }
}
