import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';
import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../home/domain/models/post_model.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../home/presentation/views/widgets/home_bottom_nav_bar.dart';
import '../../domain/models/comment_model.dart';
import 'widgets/comment_input_bottom_bar.dart';
import 'widgets/delete_post_dialog.dart';
import 'widgets/post_details_top_app_bar.dart';
import 'widgets/post_details_content.dart';

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

class _PostDetailsScaffoldState
    extends State<_PostDetailsScaffold> {
  final _db = getIt<DatabaseService>();
  final _service = getIt<PostInteractionService>();
  late final Stream<PostModel?> _postStream;
  late final Stream<List<CommentModel>> _commentsStream;

  @override
  void initState() {
    super.initState();
    _initStreams();
  }

  void _initStreams() {
    _postStream = _db
        .getDocStream(
          path: BackendEndpoints.posts,
          docId: widget.post.id,
        )
        .map(
          (data) => data != null
              ? PostModel.fromMap(data)
              : null,
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
          (list) =>
              list.map(CommentModel.fromMap).toList(),
        );
  }

  Future<void> _handleToggleLike(PostModel post) async {
    await _service.toggleLikeForCurrentUser(
      post.id,
      post.isLiked,
    );
  }

  Future<void> _handleAddComment(String text) async {
    await _service.addCommentFromCurrentUser(
      postId: widget.post.id,
      text: text,
    );
  }

  Future<void> _handleDeletePost(PostModel post) async {
    final confirmed =
        await DeletePostDialog.show(context);
    if (!confirmed || !mounted) return;

    await _service.deletePost(post.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _handleBackPressed() =>
      Navigator.of(context).pop();

  void _handleBottomNavTapped(int index) {
    Navigator.of(context).pop();
    if (index != 0) {
      homeViewKey.currentState?.onTabChanged(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: PostDetailsTopAppBar(
        onBackPressed: _handleBackPressed,
      ),
      body: _PostDetailsBody(
        initialPost: widget.post,
        postStream: _postStream,
        commentsStream: _commentsStream,
        service: _service,
        onLikePressed: _handleToggleLike,
        onDeletePressed: _handleDeletePost,
        onSendComment: _handleAddComment,
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: 0,
        onItemTapped: _handleBottomNavTapped,
      ),
    );
  }
}

class _PostDetailsBody extends StatelessWidget {
  final PostModel initialPost;
  final Stream<PostModel?> postStream;
  final Stream<List<CommentModel>> commentsStream;
  final PostInteractionService service;
  final void Function(PostModel post) onLikePressed;
  final void Function(PostModel post) onDeletePressed;
  final ValueChanged<String> onSendComment;

  const _PostDetailsBody({
    required this.initialPost,
    required this.postStream,
    required this.commentsStream,
    required this.service,
    required this.onLikePressed,
    required this.onDeletePressed,
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
              postStream: postStream,
              commentsStream: commentsStream,
              service: service,
              onLikePressed: onLikePressed,
              onDeletePressed: onDeletePressed,
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