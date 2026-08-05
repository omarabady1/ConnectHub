import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../core/utils/user_avatar.dart';
import '../../../../../utils/app_text_styles.dart';

class PostDetailCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLikePressed;
  final VoidCallback? onDeletePressed;

  const PostDetailCard({
    super.key,
    required this.post,
    this.onLikePressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kCardBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: kBrandIndigo.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                        initial:
                            post.avatarInitial ??
                            (post.authorName.isNotEmpty
                                ? post.authorName[0]
                                : '?'),
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
                  PopupMenuButton<_PostDetailAction>(
                    onSelected: (action) {
                      switch (action) {
                        case _PostDetailAction.delete:
                          onDeletePressed?.call();
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
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (post.mainImageUrl != null && post.mainImageUrl!.isNotEmpty)
            ClipRRect(
              child: AspectRatio(
                aspectRatio: 356 / 194,
                child: Image.network(
                  post.mainImageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFFEFECF8),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFEFECF8),
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: onLikePressed,
                          child: Row(
                            children: [
                              Icon(
                                post.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: post.isLiked
                                    ? kBrandIndigo
                                    : kTextSecondaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                post.likesCount.toString(),
                                style: AppTextStyles.medium12.copyWith(
                                  color: post.isLiked
                                      ? kBrandIndigo
                                      : kTextSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              color: kTextSecondaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              post.commentsCount.toString(),
                              style: AppTextStyles.medium12.copyWith(
                                color: kTextSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  post.postContent,
                  style: AppTextStyles.regular16.copyWith(
                    color: kTextDarkColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _PostDetailAction { delete }
