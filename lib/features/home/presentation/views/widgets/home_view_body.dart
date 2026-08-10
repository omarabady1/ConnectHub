import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/post_model.dart';
import 'regular_post_card.dart';
import 'user_post_card.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseService = getIt<DatabaseService>();
    final postsStream = databaseService.getDataStream(
      path: BackendEndpoints.posts,
      query: const {'orderBy': 'createdAt', 'descending': true},
    );

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: postsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = (snapshot.data ?? [])
            .map(PostModel.fromMap)
            .toList();

        if (posts.isEmpty) {
          return const Center(child: Text('No posts yet.'));
        }

        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 100,
          ),
          itemCount: posts.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final post = posts[index];
            if (post.isCurrentUser) {
              return UserPostCard(
                post: post,
                onPostDeleted: (post) =>
                    getIt<PostInteractionService>()
                        .deletePost(post.id),
              );
            }
            return RegularPostCard(post: post);
          },
        );
      },
    );
  }
}
