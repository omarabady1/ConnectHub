import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import 'comments_section.dart';
import 'liked_by_section.dart';
import 'post_detail_card.dart';

/// Body composition for Post Details view matching Figma design.
class PostDetailsViewBody extends StatelessWidget {
  const PostDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kHomeBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PostDetailCard(),
          SizedBox(height: 24),
          LikedBySection(),
          SizedBox(height: 24),
          CommentsSection(),
        ],
      ),
    );
  }
}
