import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../home/domain/models/post_model.dart';
import '../../../domain/models/comment_model.dart';
import 'post_details_view_body.dart';

class PostDetailsContent extends StatelessWidget {
  final PostModel initialPost;
  final Stream<PostModel?> postStream;
  final Stream<List<CommentModel>> commentsStream;
  final PostInteractionService service;
  final void Function(PostModel post) onLikePressed;
  final void Function(PostModel post)? onDeletePressed;

  const PostDetailsContent({
    super.key,
    required this.initialPost,
    required this.postStream,
    required this.commentsStream,
    required this.service,
    required this.onLikePressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: CombineLatestStream.list([
        postStream,
        commentsStream,
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return PostDetailsViewBody(
            post: initialPost,
            comments: const [],
            isLoadingComments: true,
            onLikePressed: () =>
                onLikePressed(initialPost),
          );
        }

        final data = snapshot.data!;
        final post = data[0] as PostModel?;
        final comments =
            data[1] as List<CommentModel>;

        if (post == null) {
          return const Center(
            child: Text('Post not found.'),
          );
        }

        return FutureBuilder<List<Map<String, String>>>(
          future: service.fetchLikedByUsers(post.likedBy),
          builder: (context, likedBySnapshot) {
            return PostDetailsViewBody(
              post: post,
              comments: comments,
              likedByUsers:
                  likedBySnapshot.data ?? const [],
              onLikePressed: () => onLikePressed(post),
              onDeletePressed: post.isCurrentUser
                  ? () => onDeletePressed?.call(post)
                  : null,
            );
          },
        );
      },
    );
  }
}
