import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../constants.dart';

import '../../cubits/home_cubit.dart';
import 'regular_post_card.dart';
import 'user_post_card.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<HomeCubit>().loadPosts();
      },
      child: Container(
        color: kHomeBackgroundColor,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return Center(child: Text(state.errMessage));
            } else if (state is HomeLoaded) {
              final posts = state.posts;

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
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  if (post.isCurrentUser) {
                    return UserPostCard(
                      post: post,
                      onPostUpdated: (updatedPost) {
                        context.read<HomeCubit>().updatePost(updatedPost);
                      },
                    );
                  } else {
                    return RegularPostCard(
                      post: post,
                      onPostUpdated: (updatedPost) {
                        context.read<HomeCubit>().updatePost(updatedPost);
                      },
                    );
                  }
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
