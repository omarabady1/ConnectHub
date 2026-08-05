import 'package:connect_hub/features/post_details/presentation/views/post_details_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final ValueChanged<String>? onPostRemoved;
  final Future<void> Function(PostModel post)? onPostDeleted;

  const UserPostCard({
    super.key,
    required this.post,
    this.onPostUpdated,
    this.onPostRemoved,
    this.onPostDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final canDeletePost =
        currentUserId != null &&
        post.userId.isNotEmpty &&
        currentUserId == post.userId &&
        onPostDeleted != null;

    return GestureDetector(
      onTap: () async {
        final updatedPost = await Navigator.of(
          context,
        ).pushNamed(PostDetailsView.routeName, arguments: post);
        if (updatedPost is PostModel && onPostUpdated != null) {
          onPostUpdated!(updatedPost);
        } else if (updatedPost is PostDetailsDeletedResult) {
          onPostRemoved?.call(updatedPost.postId);
          if (!context.mounted) return;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Post deleted.')));
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
              onDeletePressed: canDeletePost
                  ? () => _confirmDeletePost(context)
                  : null,
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

  Future<void> _confirmDeletePost(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete post?'),
        content: const Text('This post will be removed from your feed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFD92D20),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await onPostDeleted?.call(post);

      messenger.showSnackBar(const SnackBar(content: Text('Post deleted.')));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Could not delete this post. Please try again.'),
        ),
      );
    }
  }
}
