import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/home/data/models/post_model.dart';
import 'package:connect_hub/features/post_details/data/models/comment_model.dart';
import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';
import 'package:connect_hub/features/post_details/domain/entities/comment_entity.dart';
import 'package:connect_hub/features/post_details/domain/repos/post_details_repo.dart';

class PostDetailsRepoImpl implements PostDetailsRepo {
  final DatabaseService _db;
  final PostInteractionService _service;

  PostDetailsRepoImpl({
    required DatabaseService databaseService,
    required PostInteractionService postInteractionService,
  })  : _db = databaseService,
        _service = postInteractionService;

  @override
  Stream<PostModel?> getPostStream(String postId) {
    return _db
        .getDocStream(
          path: BackendEndpoints.posts,
          docId: postId,
        )
        .map(
          (data) => data != null ? PostModel.fromMap(data) : null,
        );
  }

  @override
  Stream<List<CommentEntity>> getCommentsStream(String postId) {
    return _db
        .getSubCollectionStream(
          parentPath: BackendEndpoints.posts,
          parentDocId: postId,
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

  @override
  Future<void> toggleLikeForCurrentUser(String postId, bool isLiked) {
    return _service.toggleLikeForCurrentUser(postId, isLiked);
  }

  @override
  Future<void> addCommentFromCurrentUser({
    required String postId,
    required String text,
  }) {
    return _service.addCommentFromCurrentUser(postId: postId, text: text);
  }

  @override
  Future<void> deleteComment({
    required String postId,
    required String commentId,
    required String commentUserId,
  }) {
    return _service.deleteComment(
      postId: postId,
      commentId: commentId,
      commentUserId: commentUserId,
    );
  }

  @override
  Future<void> deletePost(String postId) {
    return _service.deletePost(postId);
  }

  @override
  Future<List<Map<String, String>>> fetchLikedByUsers(List<String> likedBy) {
    return _service.fetchLikedByUsers(likedBy);
  }
}
