import 'package:connect_hub/features/post_details/domain/models/comment_model.dart';
import 'package:connect_hub/features/post_details/presentation/views/widgets/comment_item.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/app_text_styles.dart';

class CommentsSection extends StatelessWidget {
  final int totalComments;
  final List<CommentModel> comments;
  final bool isLoading;

  const CommentsSection({
    super.key,
    required this.totalComments,
    required this.comments,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Comments ($totalComments)',
            style: AppTextStyles.semiBold20.copyWith(
              color: const Color(0xFF1B1B23),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (comments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 24,
            ),
            child: Text(
              'No comments yet. Be the first to comment!',
              style: AppTextStyles.regular14.copyWith(
                color: const Color(0xFF5C5F61),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return CommentItem(comment: comments[index]);
            },
          ),
      ],
    );
  }
}
