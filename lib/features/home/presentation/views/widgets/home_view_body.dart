import 'package:connect_hub/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:connect_hub/features/home/presentation/cubits/home_cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'regular_post_card.dart';
import 'user_post_card.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeCubit>().fetchPosts();
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeFailure) {
            return Center(
              child: Text(state.errMessage),
            );
          }

          if (state is HomeSuccess) {
            final posts = state.posts;

            if (posts.isEmpty) {
              return const Center(
                child: Text('No posts yet.'),
              );
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
                        context.read<HomeCubit>().deletePost(post.id),
                  );
                }
                return RegularPostCard(post: post);
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
