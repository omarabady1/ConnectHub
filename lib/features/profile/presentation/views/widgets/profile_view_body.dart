import 'package:flutter/material.dart';
import 'profile_feed_tabs.dart';
import 'profile_header_card.dart';
import 'user_posts_grid.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          ProfileHeaderCard(),
          ProfileFeedTabs(),
          UserPostsGrid(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
