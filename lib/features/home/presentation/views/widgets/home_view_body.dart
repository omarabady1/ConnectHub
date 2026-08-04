import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../domain/models/post_model.dart';
import 'regular_post_card.dart';
import 'user_post_card.dart';

/// Scrollable feed body rendering post card items matching Figma design.
class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  static const List<PostModel> _dummyPosts = [
    PostModel(
      id: '1',
      authorName: 'Elena Rostova',
      authorRole: 'Lead Designer',
      timeAgo: '2h',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
      postTitle: 'Exploring Fluid Geometry',
      postContent:
          'Just wrapped up an exploration on structural integrity merging with fluid aesthetics. The way natural light interacts with curved glass surfaces continues to fascinate me. Thoughts?',
      mainImageUrl:
          'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&q=80&w=800',
      likesCount: 124,
      commentsCount: 18,
      isLiked: false,
      isCurrentUser: false,
    ),
    PostModel(
      id: '2',
      authorName: 'Alex Rivers',
      authorRole: 'Creative Technologist',
      timeAgo: 'Just now',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=250',
      postTitle: 'The Intersection of Code and Canvas',
      postContent:
          "Been thinking a lot about how procedural generation is changing the landscape of digital art. It's no longer just about the output, but the elegance of the algorithm itself. Who else is diving deep into shaders lately?",
      likesCount: 1,
      commentsCount: 0,
      isLiked: true,
      isCurrentUser: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kHomeBackgroundColor,
      child: ListView.separated(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100,
        ),
        itemCount: _dummyPosts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final post = _dummyPosts[index];
          if (post.isCurrentUser) {
            return UserPostCard(post: post);
          } else {
            return RegularPostCard(post: post);
          }
        },
      ),
    );
  }
}
