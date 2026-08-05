import 'dart:developer' as developer;

import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/authentication/domain/entities/user_entity.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';
import 'package:connect_hub/features/post_details/domain/models/comment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_details_state.dart';

class PostDetailsCubit extends Cubit<PostDetailsState> {
  PostDetailsCubit({
    required PostModel post,
    required this._interactionService,
    required this._databaseService,
    required this._authRepo,
  }) : super(PostDetailsInitial(post: post));

  final PostInteractionService _interactionService;
  final DatabaseService _databaseService;
  final AuthRepo _authRepo;

  Future<void> loadInitialData() async {
    emit(PostDetailsLoading(post: state.post));

    try {
      final results = await Future.wait([
        _interactionService.fetchComments(state.post.id),
        _fetchLikedByUsers(),
      ]);

      final comments = results[0] as List<CommentModel>;
      final likedByUsers = results[1] as List<Map<String, String>>;

      emit(
        PostDetailsSuccess(
          post: state.post,
          comments: comments,
          likedByUsers: likedByUsers,
        ),
      );
    } catch (e, s) {
      developer.log(
        'Failed to load post details',
        name: 'PostDetailsCubit',
        error: e,
        stackTrace: s,
      );
      emit(
        PostDetailsFailure(
          post: state.post,
          errorMessage: 'Failed to load post details',
        ),
      );
    }
  }

  Future<void> refresh() async {
    try {
      final postData =
          await _databaseService.getData(
                path: BackendEndpoints.posts,
                docId: state.post.id,
              )
              as Map<String, dynamic>?;

      PostModel updatedPost = state.post;
      if (postData != null) {
        updatedPost = PostModel.fromMap(postData);
      }

      final results = await Future.wait([
        _interactionService.fetchComments(updatedPost.id),
        _fetchLikedByUsers(likedByOverride: updatedPost.likedBy),
      ]);

      final comments = results[0] as List<CommentModel>;
      final likedByUsers = results[1] as List<Map<String, String>>;

      emit(
        PostDetailsSuccess(
          post: updatedPost,
          comments: comments,
          likedByUsers: likedByUsers,
        ),
      );
    } catch (e) {
      if (state is PostDetailsSuccess) {
        emit(
          (state as PostDetailsSuccess).copyWith(
            errorMessage: 'Failed to refresh.',
          ),
        );
      }
    }
  }

  Future<List<Map<String, String>>> _fetchLikedByUsers({
    List<String>? likedByOverride,
  }) async {
    final likedBy = likedByOverride ?? state.post.likedBy;
    if (likedBy.isEmpty) return [];

    final users = <Map<String, String>>[];
    for (final uid in likedBy.take(10)) {
      try {
        final data = await _databaseService.getData(
          path: BackendEndpoints.getUserData,
          docId: uid,
        );
        if (data is Map<String, dynamic>) {
          users.add({
            'name': (data['name'] as String?) ?? 'User',
            'role': (data['role'] as String?) ?? 'Member',
            'avatarUrl': (data['avatarUrl'] as String?) ?? '',
            'avatarInitial': (data['avatarInitial'] as String?) ?? '',
          });
        }
      } catch (_) {}
    }
    return users;
  }

  Future<void> toggleLike() async {
    if (state is! PostDetailsSuccess) return;
    final currentState = state as PostDetailsSuccess;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final wasLiked = currentState.post.isLiked;
    final oldCount = currentState.post.likesCount;
    final oldLikedBy = List<String>.from(currentState.post.likedBy);

    final newLikedBy = List<String>.from(oldLikedBy);
    if (wasLiked) {
      newLikedBy.remove(userId);
    } else {
      newLikedBy.add(userId);
    }

    emit(
      currentState.copyWith(
        post: currentState.post.copyWith(
          isLiked: !wasLiked,
          likesCount: oldCount + (wasLiked ? -1 : 1),
          likedBy: newLikedBy,
        ),
        clearErrorMessage: true,
      ),
    );

    try {
      await _interactionService.toggleLike(
        postId: currentState.post.id,
        userId: userId,
        currentlyLiked: wasLiked,
      );
    } catch (e, s) {
      developer.log(
        'Like toggle failed, reverting',
        name: 'PostDetailsCubit',
        error: e,
        stackTrace: s,
      );
      if (state is PostDetailsSuccess) {
        final st = state as PostDetailsSuccess;
        emit(
          st.copyWith(
            post: st.post.copyWith(
              isLiked: wasLiked,
              likesCount: oldCount,
              likedBy: oldLikedBy,
            ),
            errorMessage: 'Could not update like. Try again.',
          ),
        );
      }
    }
  }

  Future<void> deletePost() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final post = state.post;

    if (currentUserId == null ||
        post.userId.isEmpty ||
        post.userId != currentUserId) {
      throw StateError('You can only delete posts you created.');
    }

    try {
      await _databaseService.deleteSubCollectionData(
        parentPath: BackendEndpoints.posts,
        parentDocId: post.id,
        subCollection: BackendEndpoints.comments,
      );

      await _databaseService.deleteData(
        path: BackendEndpoints.posts,
        docId: post.id,
      );
    } catch (e, s) {
      developer.log(
        'Failed to delete post ${post.id}',
        name: 'PostDetailsCubit',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> addComment(String text) async {
    if (state is! PostDetailsSuccess) return;
    final currentState = state as PostDetailsSuccess;

    final UserEntity? currentUser = _authRepo.getCachedUser();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final authorName = (currentUser?.name.isNotEmpty ?? false)
        ? currentUser!.name
        : 'Anonymous';

    final comment = CommentModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: uid,
      authorName: authorName,
      avatarUrl: currentUser?.avatarUrl,
      avatarInitial: authorName.isNotEmpty ? authorName[0].toUpperCase() : 'A',
      content: text,
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );

    final updatedComments = [comment, ...currentState.comments];
    emit(
      currentState.copyWith(
        comments: updatedComments,
        isSendingComment: true,
        post: currentState.post.copyWith(
          commentsCount: currentState.post.commentsCount + 1,
        ),
        clearErrorMessage: true,
      ),
    );

    try {
      await _interactionService.addComment(
        postId: currentState.post.id,
        comment: comment,
      );
      if (state is PostDetailsSuccess) {
        emit((state as PostDetailsSuccess).copyWith(isSendingComment: false));
      }
    } catch (e, s) {
      developer.log(
        'Failed to add comment',
        name: 'PostDetailsCubit',
        error: e,
        stackTrace: s,
      );
      if (state is PostDetailsSuccess) {
        final st = state as PostDetailsSuccess;
        emit(
          st.copyWith(
            comments: st.comments.where((c) => c.id != comment.id).toList(),
            isSendingComment: false,
            post: st.post.copyWith(commentsCount: st.post.commentsCount - 1),
            errorMessage: 'Could not add comment. Try again.',
          ),
        );
      }
    }
  }
}
