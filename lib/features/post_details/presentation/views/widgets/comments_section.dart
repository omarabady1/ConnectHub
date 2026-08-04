import 'package:connect_hub/features/post_details/domain/models/comment_model.dart';
import 'package:connect_hub/features/post_details/presentation/views/widgets/comment_item.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/app_text_styles.dart';

/// Comments section displaying post comments list and reply options.
class CommentsSection extends StatelessWidget {
  final int totalComments;
  final List<CommentModel> comments;

  const CommentsSection({
    super.key,
    this.totalComments = 342,
    this.comments = const [
      CommentModel(
        authorName: 'Maria Garcia',
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=150',
        content: "hi, how are you?",
      ),
      CommentModel(
        authorName: 'James Chen',
        avatarUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=150',
        content: 'nice post, keep it up',
     
      ),
    ],
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
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return CommentItem(comment: comments[index]);
          },
        ),
      ],
    );
  }
}
