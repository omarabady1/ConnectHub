import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../home/domain/models/post_model.dart';
import 'profile_feed_tabs.dart';
import 'profile_header_card.dart';
import 'user_posts_grid.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  late Future<List<PostModel>> _userPostsFuture;

  @override
  void initState() {
    super.initState();
    _userPostsFuture = _loadUserPosts();
  }

  Future<List<PostModel>> _loadUserPosts() async {
    final postsData = await getIt<DatabaseService>().getData(
      path: BackendEndpoints.posts,
      query: const {'orderBy': 'createdAt', 'descending': true},
    );

    if (postsData is! List) return [];

    return postsData
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromMap)
        .where((post) => post.isCurrentUser)
        .toList();
  }

  Future<void> _deletePost(PostModel post) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null ||
        post.userId.isEmpty ||
        post.userId != currentUserId) {
      throw StateError('You can only delete posts you created.');
    }

    final databaseService = getIt<DatabaseService>();

    await databaseService.deleteSubCollectionData(
      parentPath: BackendEndpoints.posts,
      parentDocId: post.id,
      subCollection: BackendEndpoints.comments,
    );

    await databaseService.deleteData(
      path: BackendEndpoints.posts,
      docId: post.id,
    );

    final future = _loadUserPosts();
    setState(() {
      _userPostsFuture = future;
    });
    await future;
  }

  void _refreshDeletedPost(String _) {
    final future = _loadUserPosts();
    setState(() {
      _userPostsFuture = future;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthRepo>().getCachedUser();

    return RefreshIndicator(
      onRefresh: () async {
        final future = _loadUserPosts();
        setState(() {
          _userPostsFuture = future;
        });
        await future;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            ProfileHeaderCard(
              name: user?.name ?? 'User',
              email: user?.email ?? '',
              avatarUrl: user?.avatarUrl,
            ),
            const ProfileFeedTabs(),
            FutureBuilder<List<PostModel>>(
              future: _userPostsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final posts = snapshot.data ?? [];
                return UserPostsGrid(
                  posts: posts,
                  onPostRemoved: _refreshDeletedPost,
                  onPostDeleted: _deletePost,
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
