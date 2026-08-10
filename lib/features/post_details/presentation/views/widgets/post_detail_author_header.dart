import 'package:connect_hub/features/home/data/models/post_model.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../core/utils/user_avatar.dart';
import '../../../../../utils/app_text_styles.dart';

class PostDetailAuthorHeader extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onDeletePressed;

  const PostDetailAuthorHeader({
    super.key,
    required this.post,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE4E1ED), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                UserAvatar(
                  avatarUrl: post.avatarUrl,
                  initial: post.avatarInitial ??
                      (post.authorName.isNotEmpty ? post.authorName[0] : '?'),
                  border: Border.all(
                    color: const Color(0xFFE1E0FF),
                    width: 2,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.semiBold12.copyWith(
                          color: const Color(0xFF1B1B23),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        post.timeAgo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.regular14.copyWith(
                          color: const Color(0xFF5C5F61),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (onDeletePressed != null) ...[
            const SizedBox(width: 8),
            PostDetailDeleteMenu(onDeletePressed: onDeletePressed!),
          ],
        ],
      ),
    );
  }
}

class PostDetailDeleteMenu extends StatelessWidget {
  final VoidCallback onDeletePressed;

  const PostDetailDeleteMenu({super.key, required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_PostDetailAction>(
      onSelected: (action) {
        switch (action) {
          case _PostDetailAction.delete:
            onDeletePressed();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<_PostDetailAction>(
          value: _PostDetailAction.delete,
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
    );
  }
}

enum _PostDetailAction { delete }
