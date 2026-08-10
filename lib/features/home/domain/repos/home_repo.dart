import 'package:connect_hub/features/home/data/models/post_model.dart';

abstract class HomeRepo {
  Stream<List<PostModel>> getPostsStream();
  Future<void> toggleLike({
    required String postId,
    required String userId,
    required bool currentlyLiked,
  });
  Future<void> deletePost(String postId);
}
