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
        throw CustomException(
          'an unexpected error occurred, please try again later',
        );
      }
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.createUserWithEmailAndPassword: $e',
      );
      throw CustomException(
        'an unexpected error occurred, please try again later',
      );
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
        throw CustomException(
          'an unexpected error occurred, please try again later',
        );
      }
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.createUserWithEmailAndPassword: $e',
      );
      throw CustomException(
        'an unexpected error occurred, please try again later',
      );
    }
  }

  static const String _googleSignInServerClientId =
      "279659541756-7nlvqj7nj6ku5bfvs1k9039ivesb4ucu.apps.googleusercontent.com";

  bool _isGoogleSignInInitialized = false;

  Future<void> _initializeGoogleSignIn() async {
    if (_isGoogleSignInInitialized) return;

    await GoogleSignIn.instance.initialize(
      serverClientId: _googleSignInServerClientId,
    );
    _isGoogleSignInInitialized = true;
  }

  Future<User> signInWithGoogle() async {
    try {
      await _initializeGoogleSignIn();
      await GoogleSignIn.instance.signOut();
    } catch (_) {}

    late final GoogleSignInAccount googleUser;
    try {
      googleUser = await GoogleSignIn.instance.authenticate();
    } on Exception catch (e) {
      if (e is GoogleSignInException &&
          e.code == GoogleSignInExceptionCode.clientConfigurationError) {
        throw CustomException(
          'Google sign-in is not configured correctly for Android. '
          'Please add an OAuth client ID to android/app/google-services.json or call GoogleSignIn.instance.initialize(serverClientId: "<YOUR_SERVER_CLIENT_ID>").',
        );
      }
      rethrow;
    }

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final String? idToken = googleAuth.idToken;
    if (idToken == null) {
      throw CustomException('Google sign-in failed to return an ID token.');
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);

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
