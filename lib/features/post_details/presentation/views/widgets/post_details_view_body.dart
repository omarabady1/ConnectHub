import 'package:connect_hub/features/post_details/domain/models/comment_model.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import 'comments_section.dart';
import 'liked_by_section.dart';
import 'post_detail_card.dart';
import '../../../../home/domain/models/post_model.dart';

class PostDetailsViewBody extends StatelessWidget {
  final PostModel post;
  final List<CommentModel> comments;
  final bool isLoadingComments;
  final List<Map<String, String>> likedByUsers;
  final VoidCallback? onLikePressed;

  const PostDetailsViewBody({
    super.key,
    required this.post,
    required this.comments,
    this.isLoadingComments = false,
    this.likedByUsers = const [],
    this.onLikePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kHomeBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PostDetailCard(
            post: post,
            onLikePressed: onLikePressed,
          ),
          const SizedBox(height: 24),
          LikedBySection(likedByUsers: likedByUsers),
          const SizedBox(height: 24),
          CommentsSection(
            totalComments: isLoadingComments
                ? post.commentsCount
                : comments.length,
            comments: comments,
            isLoading: isLoadingComments,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
