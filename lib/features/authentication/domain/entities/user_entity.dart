class UserEntity {
  final String name;
  final String email;
  final String userID;
  final String? avatarUrl;

  UserEntity({
    required this.name,
    required this.email,
    required this.userID,
    this.avatarUrl,
  });
}
