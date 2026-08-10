import 'package:connect_hub/features/authentication/domain/entities/user_entity.dart';
import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:connect_hub/features/profile/domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  final List<PostModel> posts;

  const UserProfileModel({
    required super.user,
    super.bio,
    super.location,
    required this.posts,
  });

  factory UserProfileModel.fromEntity(
    UserProfileEntity entity, {
    List<PostModel> posts = const [],
  }) {
    return UserProfileModel(
      user: entity.user,
      bio: entity.bio,
      location: entity.location,
      posts: posts,
    );
  }

  factory UserProfileModel.fromUserEntity(
    UserEntity userEntity, {
    String bio = '',
    String location = '',
    List<PostModel> posts = const [],
  }) {
    return UserProfileModel(
      user: userEntity,
      bio: bio,
      location: location,
      posts: posts,
    );
  }
}
