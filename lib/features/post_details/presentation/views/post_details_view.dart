import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/features/post_details/domain/entities/comment_entity.dart';
import 'package:connect_hub/features/post_details/domain/repos/post_details_repo.dart';
import 'package:connect_hub/features/post_details/presentation/cubits/post_details_cubit/post_details_cubit.dart';
import 'package:connect_hub/features/post_details/presentation/cubits/post_details_cubit/post_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants.dart';
import 'package:connect_hub/features/home/data/models/post_model.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../home/presentation/views/widgets/home_bottom_nav_bar.dart';
import 'widgets/comment_input_bottom_bar.dart';
import 'widgets/delete_comment_dialog.dart';
import 'widgets/delete_post_dialog.dart';
import 'widgets/post_details_top_app_bar.dart';
import 'widgets/post_details_content.dart';

class PostDetailsView extends StatelessWidget {
  static const String routeName = '/post-details';

  final PostModel post;

  const PostDetailsView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostDetailsCubit(
        postDetailsRepo: getIt<PostDetailsRepo>(),
      )..init(post),
      child: _PostDetailsScaffold(post: post),
    );
  }
}

class PostDetailsDeletedResult {
  const PostDetailsDeletedResult({required this.postId});

  final String postId;
}

class _PostDetailsScaffold extends StatelessWidget {
  final PostModel post;

  const _PostDetailsScaffold({required this.post});

  Future<void> _handleToggleLike(BuildContext context, PostModel post) async {
    context.read<PostDetailsCubit>().toggleLike();
  }

  Future<void> _handleAddComment(BuildContext context, String text) async {
    context.read<PostDetailsCubit>().addComment(text);
  }

  Future<void> _handleDeleteComment(
    BuildContext context,
    CommentEntity comment,
  ) async {
    final confirmed = await DeleteCommentDialog.show(context);
    if (!confirmed || !context.mounted) return;

    context.read<PostDetailsCubit>().deleteComment(comment);
  }

  Future<void> _handleDeletePost(BuildContext context, PostModel post) async {
    final confirmed = await DeletePostDialog.show(context);
    if (!confirmed || !context.mounted) return;

    context.read<PostDetailsCubit>().deletePost();
  }

  void _handleBackPressed(BuildContext context) => Navigator.of(context).pop();

  void _handleBottomNavTapped(BuildContext context, int index) {
    Navigator.of(context).pop();
    if (index != 0) {
      homeViewKey.currentState?.onTabChanged(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostDetailsCubit, PostDetailsState>(
      listener: (context, state) {
        if (state is PostDeletedState) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: kHomeBackgroundColor,
        appBar: PostDetailsTopAppBar(
          onBackPressed: () => _handleBackPressed(context),
        ),
        body: _PostDetailsBody(
          initialPost: post,
          onLikePressed: (post) => _handleToggleLike(context, post),
          onDeletePressed: (post) => _handleDeletePost(context, post),
          onDeleteComment: (comment) => _handleDeleteComment(context, comment),
          onSendComment: (text) => _handleAddComment(context, text),
        ),
        bottomNavigationBar: HomeBottomNavBar(
          selectedIndex: 0,
          onItemTapped: (index) => _handleBottomNavTapped(context, index),
        ),
      ),
    );
  }
}

class _PostDetailsBody extends StatelessWidget {
  final PostModel initialPost;
  final void Function(PostModel post) onLikePressed;
  final void Function(PostModel post) onDeletePressed;
  final void Function(CommentEntity comment) onDeleteComment;
  final ValueChanged<String> onSendComment;

  const _PostDetailsBody({
    required this.initialPost,
    required this.onLikePressed,
    required this.onDeletePressed,
    required this.onDeleteComment,
    required this.onSendComment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => Future.delayed(
              const Duration(milliseconds: 500),
            ),
            child: PostDetailsContent(
              initialPost: initialPost,
              onLikePressed: onLikePressed,
              onDeletePressed: onDeletePressed,
              onDeleteComment: onDeleteComment,
            ),
          ),
        ),
        CommentInputBottomBar(
          onSendComment: onSendComment,
        ),
      ],
    );
  }
}