import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';
import 'package:flutter/material.dart';
import '../../../../home/domain/models/post_model.dart';
import 'profile_feed_tabs.dart';
import 'profile_header_card.dart';
import 'user_posts_grid.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthRepo>().getCachedUser();
    final databaseService = getIt<DatabaseService>();
    final postsStream = databaseService.getDataStream(
      path: BackendEndpoints.posts,
      query: const {
        'orderBy': 'createdAt',
        'descending': true,
      },
    );

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          ProfileHeaderCard(
            name: user?.name ?? 'User',
            email: user?.email ?? '',
            avatarUrl: user?.avatarUrl,
          ),
          const ProfileFeedTabs(),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: postsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  ),
                );
              }

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final posts = (snapshot.data ?? [])
                  .map(PostModel.fromMap)
                  .where((post) => post.isCurrentUser)
                  .toList();

              return UserPostsGrid(
                posts: posts,
                onPostDeleted: (post) =>
                    getIt<PostInteractionService>()
                        .deletePost(post.id),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
