import 'package:connect_hub/features/home/data/models/post_model.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import 'post_detail_author_header.dart';
import 'post_detail_body.dart';
import 'post_detail_image.dart';

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
          PostDetailAuthorHeader(
            post: post,
            onDeletePressed: onDeletePressed,
          ),
          if (post.mainImageUrl != null && post.mainImageUrl!.isNotEmpty)
            PostDetailImage(imageUrl: post.mainImageUrl!),
          PostDetailBody(post: post, onLikePressed: onLikePressed),
        ],
      ),
    );
  }
}
