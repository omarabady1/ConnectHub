import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/features/profile/domain/repos/profile_repo.dart';
import 'package:connect_hub/features/profile/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_feed_tabs.dart';
import 'profile_header_card.dart';
import 'user_posts_grid.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<ProfileCubit>();
      return const _ProfileViewBodyContent();
    } catch (_) {
      return BlocProvider(
        create: (context) => ProfileCubit(getIt<ProfileRepo>())..loadProfile(),
        child: const _ProfileViewBodyContent(),
      );
    }
  }
}

class _ProfileViewBodyContent extends StatelessWidget {
  const _ProfileViewBodyContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ProfileError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(state.message),
            ),
          );
        }

        if (state is ProfileLoaded) {
          final user = state.userProfile;
          final posts = state.posts;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileCubit>().loadProfile();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ProfileHeaderCard(
                    name: user.name,
                    email: user.email,
                    avatarUrl: user.avatarUrl,
                  ),
                  const ProfileFeedTabs(),
                  UserPostsGrid(
                    posts: posts,
                    onPostDeleted: (post) =>
                        context.read<ProfileCubit>().deletePost(post.id),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
