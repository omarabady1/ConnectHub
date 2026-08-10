import 'dart:io';
import 'package:connect_hub/features/authentication/domain/entities/user_entity.dart';

abstract class CreatePostRepo {
  UserEntity? getCachedUser();
  Future<void> createPost({
    required String title,
    required String content,
    File? image,
  });
}
