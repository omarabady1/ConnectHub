import 'package:connect_hub/features/post_details/presentation/views/post_details_view.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../domain/models/post_model.dart';
import 'post_card_actions.dart';
import 'post_card_header.dart';
import 'post_image.dart';

class UserPostCard extends StatelessWidget {
  final PostModel post;
  final ValueChanged<PostModel>? onPostUpdated;

  const UserPostCard({super.key, required this.post, this.onPostUpdated});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updatedPost = await Navigator.of(context).pushNamed(
          PostDetailsView.routeName,
          arguments: post,
        );
        if (updatedPost is PostModel && onPostUpdated != null) {
          onPostUpdated!(updatedPost);
        }
      },
      child: Container(
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
              style: AppTextStyles.semiBold20.copyWith(
                color: const Color(0xFF1B1B23),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.postContent,
              style: AppTextStyles.regular16.copyWith(
                color: const Color(0xFF464554),
              ),
            ),
            if (post.mainImageUrl != null && post.mainImageUrl!.isNotEmpty) ...[
              const SizedBox(height: 12),
              PostImage(imageUrl: post.mainImageUrl!),
            ],
            const SizedBox(height: 12),
            PostCardActions(
              postId: post.id,
              likesCount: post.likesCount,
              commentsCount: post.commentsCount,
              isLiked: post.isLiked,
              borderColor: kBrandIndigo.withValues(alpha: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}
