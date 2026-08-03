import 'dart:developer';

import 'package:connect_hub/core/errors/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  Future<User> createUserWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in FirebaseAuthService.createUserWithEmailAndPassword: $e with code: ${e.code}',
      );
      if (e.code == 'weak-password') {
        throw CustomException('this password is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('this email is already in use');
      } else if (e.code == 'network-request-failed') {
        throw CustomException('please check your internet connection');
      } else {
        throw CustomException('an unexpected error occurred, please try again later');
      }
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.createUserWithEmailAndPassword: $e',
      );
      throw CustomException('an unexpected error occurred, please try again later');
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in FirebaseAuthService.SignInWithEmailAndPassword: $e with code: ${e.code}',
      );
      if (e.code == 'invalid-credential') {
        throw CustomException('email or password is invalid');
      } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw CustomException('email or password is invalid');
      } else if (e.code == 'network-request-failed') {
        throw CustomException('please check your internet connection');
      } else {
        throw CustomException('an unexpected error occurred, please try again later');
      }
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.createUserWithEmailAndPassword: $e',
      );
      throw CustomException('an unexpected error occurred, please try again later');
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}

    await GoogleSignIn.instance.initialize();

    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
  }



  Future deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  Future<bool> verifyAndCheckUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.reload();
        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'user-disabled') {
          await FirebaseAuth.instance.signOut();
          return false;
        }
        return true;
      } catch (e) {
        return true;
      }
    }
    return false;
  }
}