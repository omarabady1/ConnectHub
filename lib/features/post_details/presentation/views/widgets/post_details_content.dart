import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:connect_hub/features/post_details/domain/entities/comment_entity.dart';
import 'package:connect_hub/features/post_details/presentation/cubits/post_details_cubit/post_details_cubit.dart';
import 'package:connect_hub/features/post_details/presentation/cubits/post_details_cubit/post_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_details_view_body.dart';

class PostDetailsContent extends StatelessWidget {
  final PostModel initialPost;
  final void Function(PostModel post) onLikePressed;
  final void Function(PostModel post)? onDeletePressed;
  final void Function(CommentEntity comment)? onDeleteComment;

  const PostDetailsContent({
    super.key,
    required this.initialPost,
    required this.onLikePressed,
    this.onDeletePressed,
    this.onDeleteComment,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsCubit, PostDetailsState>(
      builder: (context, state) {
        if (state is PostDetailsError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is PostDetailsLoaded) {
          return PostDetailsViewBody(
            post: state.post,
            comments: state.comments,
            isLoadingComments: state.isLoadingComments,
            likedByUsers: state.likedByUsers,
            onLikePressed: () => onLikePressed(state.post),
            onDeletePressed: state.post.isCurrentUser
                ? () => onDeletePressed?.call(state.post)
                : null,
            onDeleteComment: onDeleteComment,
          );
        }

        return PostDetailsViewBody(
          post: initialPost,
          comments: const [],
          isLoadingComments: true,
          onLikePressed: () => onLikePressed(initialPost),
        );
      },
    );
  }
}
