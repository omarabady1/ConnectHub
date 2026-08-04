import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../domain/models/post_model.dart';
import 'regular_post_card.dart';
import 'user_post_card.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  late final Future<List<PostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _loadPosts();
  }

  Future<List<PostModel>> _loadPosts() async {
    final postsData = await getIt<DatabaseService>().getData(
      path: BackendEndpoints.posts,
      query: const {'orderBy': 'createdAt', 'descending': true},
    );

    if (postsData is! List) return [];

    final firebasePosts = postsData
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromMap)
        .toList();

    return [...firebasePosts];
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _postsFuture = _loadPosts();
        setState(() {});
      },
      child: Container(
        color: kHomeBackgroundColor,
        child: FutureBuilder<List<PostModel>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            final posts = snapshot.data ?? [];
      
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
      
            return ListView.separated(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 100,
              ),
              itemCount: posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final post = posts[index];
                if (post.isCurrentUser) {
                  return UserPostCard(post: post);
                } else {
                  return RegularPostCard(post: post);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
