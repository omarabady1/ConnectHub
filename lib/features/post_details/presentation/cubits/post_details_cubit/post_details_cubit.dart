import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:connect_hub/features/post_details/domain/entities/comment_entity.dart';
import 'package:connect_hub/features/post_details/domain/repos/post_details_repo.dart';
import 'post_details_state.dart';

class PostDetailsCubit extends Cubit<PostDetailsState> {
  final PostDetailsRepo _repo;
  StreamSubscription<List<dynamic>>? _combinedSubscription;
  PostModel? _currentPost;

  PostDetailsCubit({required PostDetailsRepo postDetailsRepo})
    : _repo = postDetailsRepo,
      super(const PostDetailsInitial());

  void init(PostModel initialPost) {
    _currentPost = initialPost;
    emit(
      PostDetailsLoaded(
        post: initialPost,
        comments: const [],
        isLoadingComments: true,
      ),
    );

    _combinedSubscription?.cancel();
    _combinedSubscription =
        CombineLatestStream.list([
          _repo.getPostStream(initialPost.id),
          _repo.getCommentsStream(initialPost.id),
        ]).listen(
          (data) async {
            final post = data[0] as PostModel?;
            final comments = data[1] as List<CommentEntity>;

            if (post == null) {
              emit(const PostDetailsError('Post not found.'));
              return;
            }

            _currentPost = post;
            final likedByUsers = await _repo.fetchLikedByUsers(post.likedBy);

            emit(
              PostDetailsLoaded(
                post: post,
                comments: comments,
                likedByUsers: likedByUsers,
                isLoadingComments: false,
              ),
            );
          },
          onError: (error) {
            emit(PostDetailsError(error.toString()));
          },
        );
  }

  Future<void> toggleLike() async {
    final post = _currentPost;
    if (post == null) return;
    try {
      await _repo.toggleLikeForCurrentUser(post.id, post.isLiked);
    } catch (e) {
      //
    }
  }

  Future<void> addComment(String text) async {
    final post = _currentPost;
    if (post == null || text.trim().isEmpty) return;
    try {
      await _repo.addCommentFromCurrentUser(postId: post.id, text: text.trim());
    } catch (e) {
      //
    }
  }

  Future<void> deleteComment(CommentEntity comment) async {
    final post = _currentPost;
    if (post == null) return;
    try {
      await _repo.deleteComment(
        postId: post.id,
        commentId: comment.id,
        commentUserId: comment.userId,
      );
    } catch (e) {
      //
    }
  }

  Future<void> deletePost() async {
    final post = _currentPost;
    if (post == null) return;
    try {
      await _repo.deletePost(post.id);
      emit(PostDeletedState(post.id));
    } catch (e) {
      emit(PostDetailsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _combinedSubscription?.cancel();
    return super.close();
  }
}
