import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';
import 'package:connect_hub/features/post_details/presentation/cubits/post_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants.dart';
import '../../../home/domain/models/post_model.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../home/presentation/views/widgets/home_bottom_nav_bar.dart';
import 'widgets/comment_input_bottom_bar.dart';
import 'widgets/post_details_top_app_bar.dart';
import 'widgets/post_details_view_body.dart';

class PostDetailsView extends StatelessWidget {
  static const String routeName = '/post-details';

  final PostModel post;

  const PostDetailsView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostDetailsCubit(
        post: post,
        interactionService:
            getIt<PostInteractionService>(),
        databaseService: getIt<DatabaseService>(),
        authRepo: getIt<AuthRepo>(),
      )..loadInitialData(),
      child: const _PostDetailsScaffold(),
    );
  }
}

class _PostDetailsScaffold extends StatelessWidget {
  const _PostDetailsScaffold();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostDetailsCubit>();

    return BlocListener<PostDetailsCubit, PostDetailsState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != null &&
          curr.errorMessage != prev.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final updatedPost = cubit.state.post;
          Navigator.of(context).pop(updatedPost);
        },
        child: Scaffold(
          backgroundColor: kHomeBackgroundColor,
          appBar: PostDetailsTopAppBar(
            onBackPressed: () {
              Navigator.of(context).pop(cubit.state.post);
            },
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<PostDetailsCubit, PostDetailsState>(
                  builder: (context, state) {
                    return PostDetailsViewBody(
                      post: state.post,
                      comments: state.comments,
                      isLoadingComments: state is PostDetailsLoading || state is PostDetailsInitial,
                      likedByUsers: state.likedByUsers,
                      onLikePressed: cubit.toggleLike,
                    );
                  },
                ),
              ),
              BlocBuilder<PostDetailsCubit, PostDetailsState>(
                buildWhen: (prev, curr) =>
                    prev.isSendingComment != curr.isSendingComment,
                builder: (context, state) {
                  return CommentInputBottomBar(
                    onSendComment: cubit.addComment,
                    isSending: state.isSendingComment,
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: HomeBottomNavBar(
            selectedIndex: 0,
            onItemTapped: (index) {
              final updatedPost = cubit.state.post;
              Navigator.of(context).pop(updatedPost);
              if (index != 0) {
                homeViewKey.currentState?.onTabChanged(index);
              }
            },
          ),
        ),
      ),
    );
  }
}
