import 'package:connect_hub/features/home/data/models/post_model.dart';
import 'package:connect_hub/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRepo {
  UserProfileEntity? getCachedUserProfile();
  Stream<List<PostModel>> getUserPostsStream(String userId);
  Future<void> deletePost(String postId);
  Future<void> signOut();
}
