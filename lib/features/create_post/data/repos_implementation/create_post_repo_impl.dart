import 'dart:io';
import 'package:connect_hub/core/services/cloud_storage_service.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/authentication/domain/entities/user_entity.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:connect_hub/features/create_post/domain/repos/create_post_repo.dart';
import 'package:connect_hub/features/home/data/models/post_model.dart';

class CreatePostRepoImpl implements CreatePostRepo {
  final DatabaseService databaseService;
  final CloudStorageService cloudStorageService;
  final AuthRepo authRepo;

  CreatePostRepoImpl({
    required this.databaseService,
    required this.cloudStorageService,
    required this.authRepo,
  });

  @override
  UserEntity? getCachedUser() => authRepo.getCachedUser();

  @override
  Future<void> createPost({
    required String title,
    required String content,
    File? image,
  }) async {
    final postId = DateTime.now().microsecondsSinceEpoch.toString();
    final imageUrl = image == null
        ? null
        : await cloudStorageService.uploadFile(image, postId);
    final user = authRepo.getCachedUser();
    final authorName = _currentUserName(user);

    final post = PostModel(
      id: postId,
      userId: user?.userID ?? '',
      authorName: authorName,
      authorRole: 'Member',
      timeAgo: DateTime.now().difference(DateTime.now()).inSeconds.toString(),
      avatarUrl: user?.avatarUrl,
      avatarInitial: _currentUserInitial(authorName),
      postTitle: title,
      postContent: content,
      mainImageUrl: imageUrl,
      likesCount: 0,
      commentsCount: 0,
    );

    await databaseService.addData(
      path: BackendEndpoints.posts,
      data: post.toMap(),
      docId: postId,
    );
  }

  String _currentUserName(UserEntity? user) {
    if (user == null || user.name.trim().isEmpty) return 'Anonymous';
    return user.name;
  }

  String _currentUserInitial(String userName) {
    return userName.isEmpty ? 'A' : userName[0].toUpperCase();
  }
}
