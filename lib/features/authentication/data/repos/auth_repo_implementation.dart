import 'dart:convert';
import 'dart:developer';

import 'package:connect_hub/constants.dart';
import 'package:connect_hub/core/errors/exceptions.dart';
import 'package:connect_hub/core/errors/failures.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/services/firebase_auth_service.dart';
import 'package:connect_hub/core/services/shared_preferences_singleton.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/authentication/data/models/user_model.dart';
import 'package:connect_hub/features/authentication/domain/entities/user_entity.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImplementation implements AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;

  AuthRepoImplementation({
    required this.firebaseAuthService,
    required this.databaseService,
  });

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    User? user;
    try {
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        emailAddress: email,
        password: password,
      );
      UserEntity userEntity = UserEntity(
        name: name,
        email: email,
        userID: user.uid,
        avatarUrl: user.photoURL,
      );
      await addUser(user: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      deleteUser(user);
      return left(ServerFailure(e.message));
    } catch (e) {
      deleteUser(user);
      log(
        'Exception in AuthRepoImplementation.createUserWithEmailAndPassword: $e',
      );
      return left(
        ServerFailure('Unexpected Error Happened, Please Try Again Later'),
      );
    }
  }

  void deleteUser(User? user) {
    if (user != null) {
      firebaseAuthService.deleteUser();
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
        emailAddress: email,
        password: password,
      );

      UserEntity userEntity;
      try {
        userEntity = await getUserData(userID: user.uid);
      } on CustomException {
        userEntity = UserModel.fromFirebaseUser(user);
        await addUser(user: userEntity);
      }

      await saveUserData(user: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in AuthRepoImplementation.signInWithEmailAndPassword: $e');
      return left(
        ServerFailure('Unexpected Error Happened, Please Try Again Later'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();
      UserEntity userEntity = UserModel.fromFirebaseUser(user);
      if (!await checkIfUserExists(user.uid)) {
        await addUser(user: userEntity);
      } else {
        final existingUser = await getUserData(userID: user.uid);
        userEntity = UserModel(
          name: existingUser.name.isNotEmpty ? existingUser.name : userEntity.name,
          email: existingUser.email.isNotEmpty ? existingUser.email : userEntity.email,
          userID: existingUser.userID,
          avatarUrl: userEntity.avatarUrl ?? existingUser.avatarUrl,
        );
        if (existingUser.avatarUrl != userEntity.avatarUrl) {
          await addUser(user: userEntity);
        }
      }
      await saveUserData(user: userEntity);
      return right(userEntity);
    } catch (e) {
      deleteUser(user);
      log('Exception in AuthRepoImplementation.signInWithGoogle: $e');
      return left(
        ServerFailure('Unexpected Error Happened, Please Try Again Later'),
      );
    }
  }

  @override
  Future<dynamic> addUser({required UserEntity user}) async {
    databaseService.addData(
      path: BackendEndpoints.addUserData,
      data: UserModel.fromEntity(user).toMap(),
      docId: user.userID,
    );
  }

  @override
  Future<dynamic> saveUserData({required UserEntity user}) async {
    var jsonData = UserModel.fromEntity(user).toMap();
    Prefs.setString(kUserData, jsonEncode(jsonData));
  }

  @override
  Future<bool> checkIfUserExists(String uid) async {
    return await databaseService.checkIfValueExists('users', 'userID', uid);
  }

  @override
  Future<UserEntity> getUserData({required String userID}) async {
    var userData = await databaseService.getData(
      path: BackendEndpoints.getUserData,
      docId: userID,
    );
    if (userData == null) {
      throw CustomException('User data not found.');
    }
    if (userData is! Map<String, dynamic>) {
      throw CustomException('Invalid user data format.');
    }
    return UserModel.fromJson(userData);
  }
}
