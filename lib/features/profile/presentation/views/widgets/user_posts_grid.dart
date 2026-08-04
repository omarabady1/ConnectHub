import 'package:flutter/material.dart';
import '../../../../home/domain/models/post_model.dart';
import '../../../../home/presentation/views/widgets/user_post_card.dart';

class UserPostsGrid extends StatelessWidget {
  final List<PostModel> posts;

  const UserPostsGrid({
    super.key,
    this.posts = const [
      PostModel(
        id: 'user_post_1',
        authorName: 'Walter White',
        authorRole: 'Chemesit',
        timeAgo: '2h ago',
        avatarUrl:
            'https://static.wikia.nocookie.net/breakingbad/images/e/e7/BB-S5B-Walt-590.jpg/revision/latest/scale-to-width-down/1000?cb=20250728222301',
        isCurrentUser: true,
        postTitle: 'About Chemesitry',
        postContent:
            'Chemistry is the scientific study of matter, including its properties, how matter behaves when it interacts with other substances, and how it changes.',
        mainImageUrl:
            'https://static.wikia.nocookie.net/breakingbad/images/1/17/BB_516_S.jpg/revision/latest?cb=20170418201404',
        likesCount: 1200,
        commentsCount: 84,
        isLiked: true,
      ),
    ],
  });

  @override
  Widget build(BuildContext context) {
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
