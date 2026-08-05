import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import 'comments_section.dart';
import 'liked_by_section.dart';
import 'post_detail_card.dart';
import '../../../../home/domain/models/post_model.dart';

class PostDetailsViewBody extends StatelessWidget {
  final PostModel post;
  const PostDetailsViewBody({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kHomeBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PostDetailCard(post: post),
          SizedBox(height: 24),
          LikedBySection(),
          SizedBox(height: 24),
          CommentsSection(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
