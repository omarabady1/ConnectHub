import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/post_details/domain/models/comment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      final docRef =
          _firestore.collection(BackendEndpoints.posts).doc(postId);

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

  Future<void> toggleLikeForCurrentUser(String postId, bool isLiked) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    await toggleLike(
      postId: postId,
      userId: userId,
      currentlyLiked: isLiked,
    );
  }

  Future<List<CommentModel>> fetchComments(
    String postId, {
    int? limit,
  }) async {
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

  Future<void> addCommentFromCurrentUser({
    required String postId,
    required String text,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final userData = await _db.getData(
      path: BackendEndpoints.getUserData,
      docId: userId,
    );
    final authorName =
        (userData is Map<String, dynamic>)
            ? (userData['name'] as String?) ?? 'Anonymous'
            : 'Anonymous';
    final avatarUrl =
        (userData is Map<String, dynamic>)
            ? userData['avatarUrl'] as String?
            : null;

    final comment = CommentModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: userId,
      authorName: authorName,
      avatarUrl: avatarUrl,
      avatarInitial: authorName.isNotEmpty
          ? authorName[0].toUpperCase()
          : 'A',
      content: text,
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );

    await addComment(postId: postId, comment: comment);
  }

  Future<void> deletePost(String postId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      throw StateError('Not authenticated.');
    }

    await _db.deleteSubCollectionData(
      parentPath: BackendEndpoints.posts,
      parentDocId: postId,
      subCollection: BackendEndpoints.comments,
    );
    await _db.deleteData(
      path: BackendEndpoints.posts,
      docId: postId,
    );
  }

  Future<List<Map<String, String>>> fetchLikedByUsers(
    List<String> likedBy,
  ) async {
    if (likedBy.isEmpty) return [];
    final users = <Map<String, String>>[];
    for (final uid in likedBy.take(10)) {
      try {
        final data = await _db.getData(
          path: BackendEndpoints.getUserData,
          docId: uid,
        );
        if (data is Map<String, dynamic>) {
          users.add({
            'name': (data['name'] as String?) ?? 'User',
            'role': (data['role'] as String?) ?? 'Member',
            'avatarUrl': (data['avatarUrl'] as String?) ?? '',
            'avatarInitial':
                (data['avatarInitial'] as String?) ?? '',
          });
        }
      } catch (_) {}
    }
    return users;
  }
}
