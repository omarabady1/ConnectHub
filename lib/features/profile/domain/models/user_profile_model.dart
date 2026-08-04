import '../../../home/domain/models/post_model.dart';

class UserProfileModel {
  final String name;
  final String avatarUrl;
  final String bio;
  final String location;
  final List<PostModel> posts;

  const UserProfileModel({
    required this.name,
    required this.avatarUrl,
    required this.bio,
    required this.location,
    required this.posts,
  });
}
