import 'package:connect_hub/constants.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/services/shared_preferences_singleton.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:connect_hub/features/home/data/models/post_model.dart';
import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';
import 'package:connect_hub/features/profile/domain/entities/user_profile_entity.dart';
import 'package:connect_hub/features/profile/domain/repos/profile_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepoImpl implements ProfileRepo {
  final AuthRepo _auth;
  final DatabaseService _db;
  final PostInteractionService _service;

  ProfileRepoImpl({
    required AuthRepo authRepo,
    required DatabaseService databaseService,
    required PostInteractionService postInteractionService,
  })  : _auth = authRepo,
        _db = databaseService,
        _service = postInteractionService;

  @override
  UserProfileEntity? getCachedUserProfile() {
    final user = _auth.getCachedUser();
    if (user == null) return null;
    return UserProfileEntity(user: user);
  }

  @override
  Stream<List<PostModel>> getUserPostsStream(String userId) {
    return _db
        .getDataStream(
          path: BackendEndpoints.posts,
          query: const {
            'orderBy': 'createdAt',
            'descending': true,
          },
        )
        .map(
          (list) => list
              .map(PostModel.fromMap)
              .where((post) => post.userId == userId || post.isCurrentUser)
              .toList(),
        );
  }

  @override
  Future<void> deletePost(String postId) {
    return _service.deletePost(postId);
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Prefs.removeString(kUserData);
  }
}
