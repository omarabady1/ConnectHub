import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../core/utils/user_avatar.dart';
import '../../../../../utils/app_text_styles.dart';

class PostCardHeader extends StatelessWidget {
  final String authorName;
  final String authorRole;
  final String timeAgo;
  final String? avatarUrl;
  final String? avatarInitial;
  final bool isCurrentUser;
  final VoidCallback? onDeletePressed;

  const PostCardHeader({
    super.key,
    required this.authorName,
    required this.authorRole,
    required this.timeAgo,
    this.avatarUrl,
    this.avatarInitial,
    this.isCurrentUser = false,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatar(
          avatarUrl: avatarUrl,
          initial:
              avatarInitial ?? (authorName.isNotEmpty ? authorName[0] : '?'),
          size: 44,
          border: isCurrentUser
              ? Border.all(color: kBrandIndigo, width: 2)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    authorName,
                    style: isCurrentUser
                        ? AppTextStyles.semiBold12.copyWith(
                            color: const Color(0xFF1B1B23),
                          )
                        : AppTextStyles.medium12.copyWith(
                            color: const Color(0xFF1B1B23),
                          ),
                  ),
                  if (isCurrentUser) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'YOUR POST',
                        style: AppTextStyles.regular10.copyWith(
                          color: const Color(0xFF4648D4),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '$authorRole • $timeAgo',
                style: AppTextStyles.regular14.copyWith(
                  color: const Color(0xFF5C5F61),
                ),
              ),
            ],
          ),
        ),
        if (onDeletePressed != null)
          PopupMenuButton<_PostCardAction>(
            onSelected: (action) {
              switch (action) {
                case _PostCardAction.delete:
                  onDeletePressed?.call();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<_PostCardAction>(
                value: _PostCardAction.delete,
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFD92D20),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Delete post',
                      style: AppTextStyles.medium12.copyWith(
                        color: const Color(0xFFD92D20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            icon: const Icon(
              Icons.more_horiz,
              color: kTextSecondaryColor,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
      ],
    );
  }
}

enum _PostCardAction { delete }
