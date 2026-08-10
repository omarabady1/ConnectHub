import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/home/data/models/post_model.dart';
import 'package:connect_hub/features/home/domain/repos/home_repo.dart';
import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';

class HomeRepoImpl implements HomeRepo {
  final DatabaseService databaseService;
  final PostInteractionService postInteractionService;

  HomeRepoImpl({
    required this.databaseService,
    required this.postInteractionService,
  });

  @override
  Stream<List<PostModel>> getPostsStream() {
    return databaseService.getDataStream(
      path: BackendEndpoints.posts,
      query: const {'orderBy': 'createdAt', 'descending': true},
    ).map((data) => data.map(PostModel.fromMap).toList());
  }

  @override
  Future<void> toggleLike({
    required String postId,
    required String userId,
    required bool currentlyLiked,
  }) {
    return postInteractionService.toggleLike(
      postId: postId,
      userId: userId,
      currentlyLiked: currentlyLiked,
    );
  }

  @override
  Future<void> deletePost(String postId) {
    return postInteractionService.deletePost(postId);
  }
}
