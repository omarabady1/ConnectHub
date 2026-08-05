import 'package:flutter/material.dart';
import '../../../../home/domain/models/post_model.dart';
import '../../../../home/presentation/views/widgets/user_post_card.dart';

class UserPostsGrid extends StatelessWidget {
  final List<PostModel> posts;

  const UserPostsGrid({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'No posts yet',
            style: TextStyle(
              color: Color(0xFF5C5F61),
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return UserPostCard(post: posts[index]);
      },
    );
  }
}
