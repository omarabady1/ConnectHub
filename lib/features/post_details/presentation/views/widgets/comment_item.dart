import 'package:connect_hub/features/post_details/domain/entities/comment_entity.dart';
import 'package:connect_hub/utils/app_text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/user_avatar.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  final void Function(CommentEntity comment)? onDeleteComment;

  const CommentItem({
    super.key,
    required this.comment,
    this.onDeleteComment,
  });

  bool get _isCommentOwner {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return currentUserId != null &&
        currentUserId == comment.userId;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatar(
          avatarUrl: comment.avatarUrl,
          initial: comment.avatarInitial ??
              (comment.authorName.isNotEmpty
                  ? comment.authorName[0]
                  : '?'),
          size: 32,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F2FE),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.authorName,
                      style:
                          AppTextStyles.semiBold12.copyWith(
                        color: const Color(0xFF1B1B23),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          comment.timeAgo,
                          style: AppTextStyles.regular14
                              .copyWith(
                            color: const Color(0xFF9E9EA7),
                            fontSize: 11,
                          ),
                        ),
                        if (_isCommentOwner) ...[
                          const SizedBox(width: 4),
                          _DeleteCommentButton(
                            onTap: () => onDeleteComment
                                ?.call(comment),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: AppTextStyles.regular14.copyWith(
                    color: const Color(0xFF1B1B23),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DeleteCommentButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DeleteCommentButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.delete_outline,
          size: 16,
          color: Color(0xFF9E9EA7),
        ),
      ),
    );
  }
}
