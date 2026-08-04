import 'package:connect_hub/features/post_details/presentation/views/post_details_view.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../domain/models/post_model.dart';
import 'post_card_actions.dart';
import 'post_card_header.dart';

class RegularPostCard extends StatelessWidget {
  final PostModel post;

  const RegularPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(PostDetailsView.routeName);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            isCurrentUser: post.isCurrentUser,
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
          if (post.mainImageUrl != null && post.mainImageUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 326 / 178,
                child: Image.network(
                  post.mainImageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFFE9E6F3),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFE9E6F3),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: kTextSecondaryColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          PostCardActions(
            likesCount: post.likesCount,
            commentsCount: post.commentsCount,
            isLiked: post.isLiked,
          ),
        ],
      ),
    ),
    );
  }
}
