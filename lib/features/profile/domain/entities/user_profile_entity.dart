import 'package:connect_hub/features/authentication/domain/entities/user_entity.dart';

class UserProfileEntity {
  final UserEntity user;
  final String bio;
  final String location;

  const UserProfileEntity({
    required this.user,
    this.bio = '',
    this.location = '',
  });

  String get name => user.name;
  String get email => user.email;
  String get userID => user.userID;
  String? get avatarUrl => user.avatarUrl;
}
