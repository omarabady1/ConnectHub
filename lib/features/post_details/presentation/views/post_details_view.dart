import 'dart:developer' as developer;

import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';
import 'package:connect_hub/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../constants.dart';
import '../../../home/domain/models/post_model.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../home/presentation/views/widgets/home_bottom_nav_bar.dart';
import '../../domain/models/comment_model.dart';
import 'widgets/comment_input_bottom_bar.dart';
import 'widgets/post_details_top_app_bar.dart';
import 'widgets/post_details_view_body.dart';

class PostDetailsView extends StatelessWidget {
  static const String routeName = '/post-details';

  final PostModel post;

  const PostDetailsView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return _PostDetailsScaffold(post: post);
  }
}

class PostDetailsDeletedResult {
  const PostDetailsDeletedResult({required this.postId});

  final String postId;
}

class _PostDetailsScaffold extends StatefulWidget {
  final PostModel post;

  const _PostDetailsScaffold({required this.post});

  @override
  State<_PostDetailsScaffold> createState() =>
      _PostDetailsScaffoldState();
}

class _PostDetailsScaffoldState extends State<_PostDetailsScaffold> {
  final _db = getIt<DatabaseService>();
  final _service = getIt<PostInteractionService>();
  late final Stream<PostModel?> _postStream;
  late final Stream<List<CommentModel>> _commentsStream;

  @override
  void initState() {
    super.initState();
    _postStream = _db
        .getDocStream(
          path: BackendEndpoints.posts,
          docId: widget.post.id,
        )
        .map(
          (data) =>
              data != null ? PostModel.fromMap(data) : null,
        );

    _commentsStream = _db
        .getSubCollectionStream(
          parentPath: BackendEndpoints.posts,
          parentDocId: widget.post.id,
          subCollection: BackendEndpoints.comments,
          query: const {
            'orderBy': 'createdAt',
            'descending': true,
          },
        )
        .map(
          (list) => list.map(CommentModel.fromMap).toList(),
        );
  }

  Future<void> _toggleLike(PostModel post) async {
    try {
      await _service.toggleLikeForCurrentUser(
        post.id,
        post.isLiked,
      );
    } catch (e, s) {
      developer.log(
        'Like toggle failed',
        name: 'PostDetailsView',
        error: e,
        stackTrace: s,
      );
      if (!mounted) return;
      showCustomSnackBar(
        context,
        'Could not update like. Try again.',
      );
    }
  }

  Future<void> _addComment(String text) async {
    try {
      await _service.addCommentFromCurrentUser(
        postId: widget.post.id,
        text: text,
      );
    } catch (e, s) {
      developer.log(
        'Failed to add comment',
        name: 'PostDetailsView',
        error: e,
        stackTrace: s,
      );
      if (!mounted) return;
      showCustomSnackBar(
        context,
        'Could not add comment. Try again.',
      );
    }
  }

  Future<void> _confirmDeletePost(PostModel post) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete post?'),
        content: const Text(
          'This post will be removed from your feed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFD92D20),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return;

    try {
      await _service.deletePost(post.id);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      showCustomSnackBar(
        context,
        'Could not delete this post. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: PostDetailsTopAppBar(
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.delayed(
                const Duration(milliseconds: 500),
              ),
              child: StreamBuilder<List<dynamic>>(
                stream: CombineLatestStream.list([
                  _postStream,
                  _commentsStream,
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
                      post: widget.post,
                      comments: const [],
                      isLoadingComments: true,
                      onLikePressed: () =>
                          _toggleLike(widget.post),
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

                  return FutureBuilder<
                    List<Map<String, String>>
                  >(
                    future:
                        _service.fetchLikedByUsers(post.likedBy),
                    builder: (context, likedBySnapshot) {
                      return PostDetailsViewBody(
                        post: post,
                        comments: comments,
                        likedByUsers:
                            likedBySnapshot.data ?? const [],
                        onLikePressed: () => _toggleLike(post),
                        onDeletePressed: post.isCurrentUser
                            ? () => _confirmDeletePost(post)
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          CommentInputBottomBar(onSendComment: _addComment),
        ],
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: 0,
        onItemTapped: (index) {
          Navigator.of(context).pop();
          if (index != 0) {
            homeViewKey.currentState?.onTabChanged(index);
          }
        },
      ),
    );
  }
}