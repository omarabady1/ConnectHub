import 'package:connect_hub/core/errors/failures.dart';
import 'package:connect_hub/features/authentication/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  );
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future addUser({required UserEntity user});
  Future saveUserData({required UserEntity user});
  UserEntity? getCachedUser();
  Future<bool> checkIfUserExists(String value);
  Future<UserEntity> getUserData({required String userID});
}
