import 'package:connect_hub/features/authentication/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.email,
    required super.userID,
    super.avatarUrl,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
      userID: user.uid,
      avatarUrl: user.photoURL,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userID: json['userID'] ?? '',
      avatarUrl: json['avatarUrl'],
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      name: entity.name,
      email: entity.email,
      userID: entity.userID,
      avatarUrl: entity.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'userID': userID,
      'avatarUrl': avatarUrl,
    };
  }
}
