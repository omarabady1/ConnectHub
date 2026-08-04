import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../domain/models/post_model.dart';
import 'post_card_actions.dart';
import 'post_card_header.dart';

class UserPostCard extends StatelessWidget {
  final PostModel post;

  const UserPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBrandIndigo, width: 2),
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
          PostCardHeader(
            authorName: post.authorName,
            authorRole: post.authorRole,
            timeAgo: post.timeAgo,
            avatarUrl: post.avatarUrl,
            avatarInitial: post.avatarInitial,
            isCurrentUser: true,
          ),
          const SizedBox(height: 12),
          Text(
            post.postTitle,
            style: AppTextStyles.postTitleHeading,
          ),
          const SizedBox(height: 8),
          Text(
            post.postContent,
            style: AppTextStyles.postBody,
          ),
          if (post.tags != null && post.tags!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.tags!.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9E6F3),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tag,
                    style: AppTextStyles.hashtagChipText,
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 12),
          PostCardActions(
            likesCount: post.likesCount,
            commentsCount: post.commentsCount,
            isLiked: post.isLiked,
            borderColor: kBrandIndigo.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
