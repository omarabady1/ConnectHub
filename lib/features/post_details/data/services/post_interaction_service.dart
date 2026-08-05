import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/post_details/domain/models/comment_model.dart';

class PostInteractionService {
  PostInteractionService({required DatabaseService databaseService})
    : _db = databaseService;

  final DatabaseService _db;
  final _firestore = FirebaseFirestore.instance;

  Future<void> toggleLike({
    required String postId,
    required String userId,
    required bool currentlyLiked,
  }) async {
    try {
      final docRef = _firestore.collection(BackendEndpoints.posts).doc(postId);

      if (currentlyLiked) {
        await docRef.update({
          'likedBy': FieldValue.arrayRemove([userId]),
          'likesCount': FieldValue.increment(-1),
        });
      } else {
        await docRef.update({
          'likedBy': FieldValue.arrayUnion([userId]),
          'likesCount': FieldValue.increment(1),
        });
      }
    } catch (e, s) {
      log(
        'Failed to toggle like on $postId',
        name: 'PostInteractionService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<List<CommentModel>> fetchComments(String postId, {int? limit}) async {
    try {
      final query = <String, dynamic>{
        'orderBy': 'createdAt',
        'descending': true,
      };
      if (limit != null) {
        query['limit'] = limit;
      }
      final data = await _db.getSubCollectionData(
        parentPath: BackendEndpoints.posts,
        parentDocId: postId,
        subCollection: BackendEndpoints.comments,
        query: query,
      );

      return data.map(CommentModel.fromMap).toList();
    } catch (e, s) {
      log(
        'Failed to fetch comments for $postId',
        name: 'PostInteractionService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// the post's `commentsCount`.
  Future<void> addComment({
    required String postId,
    required CommentModel comment,
  }) async {
    try {
      await _db.addSubCollectionData(
        parentPath: BackendEndpoints.posts,
        parentDocId: postId,
        subCollection: BackendEndpoints.comments,
        data: comment.toMap(),
        docId: comment.id,
      );

      await _db.updateData(
        path: BackendEndpoints.posts,
        docId: postId,
        data: {'commentsCount': FieldValue.increment(1)},
      );
    } catch (e, s) {
      log(
        'Failed to add comment to $postId',
        name: 'PostInteractionService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
