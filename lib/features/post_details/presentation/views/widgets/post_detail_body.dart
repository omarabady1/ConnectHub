import 'package:connect_hub/features/home/data/models/post_model.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';
import 'post_detail_actions.dart';

class PostDetailBody extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLikePressed;

  const PostDetailBody({
    super.key,
    required this.post,
    this.onLikePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostDetailActions(post: post, onLikePressed: onLikePressed),
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
    );
  }
}
