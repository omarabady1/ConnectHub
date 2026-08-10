import 'package:connect_hub/features/home/data/models/post_model.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class PostDetailActions extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLikePressed;

  const PostDetailActions({
    super.key,
    required this.post,
    this.onLikePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onLikePressed,
          child: Row(
            children: [
              Icon(
                post.isLiked ? Icons.favorite : Icons.favorite_border,
                color: post.isLiked ? kBrandIndigo : kTextSecondaryColor,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                post.likesCount.toString(),
                style: AppTextStyles.medium12.copyWith(
                  color: post.isLiked ? kBrandIndigo : kTextSecondaryColor,
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
    );
  }
}
