import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:connect_hub/features/post_details/domain/entities/comment_entity.dart';

abstract class PostDetailsRepo {
  Stream<PostModel?> getPostStream(String postId);
  Stream<List<CommentEntity>> getCommentsStream(String postId);
  Future<void> toggleLikeForCurrentUser(String postId, bool isLiked);
  Future<void> addCommentFromCurrentUser({
    required String postId,
    required String text,
  });
  Future<void> deleteComment({
    required String postId,
    required String commentId,
    required String commentUserId,
  });
  Future<void> deletePost(String postId);
  Future<List<Map<String, String>>> fetchLikedByUsers(List<String> likedBy);
}
