import 'dart:convert';

import 'package:connect_hub/constants.dart';
import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/services/shared_preferences_singleton.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/authentication/data/models/user_model.dart';
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

  UserModel? _currentUser() {
    final userJson = Prefs.getString(kUserData);
    if (userJson == null || userJson.isEmpty) return null;

    final decoded = jsonDecode(userJson);
    if (decoded is! Map<String, dynamic>) return null;

    return UserModel.fromJson(decoded);
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

  @override
  Widget build(BuildContext context) {
    final user = _currentUser();

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
                return UserPostsGrid(posts: posts);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
