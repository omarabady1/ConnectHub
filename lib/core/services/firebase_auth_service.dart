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
        throw CustomException('كلمة المرور ضعيفة');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('هذا الحساب موجود بالفعل. برجاء تسجيل الدخول');
      } else if (e.code == 'network-request-failed') {
        throw CustomException('يرجى التحقق من اتصال الانترنت');
      } else {
        throw CustomException('حدث خطأ ما، برجاء المحاولة لاحقًا');
      }
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.createUserWithEmailAndPassword: $e',
      );
      throw CustomException('حدث خطأ ما، برجاء المحاولة لاحقًا');
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
        throw CustomException('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw CustomException('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      } else if (e.code == 'network-request-failed') {
        throw CustomException('يرجى التحقق من اتصال الانترنت');
      } else {
        throw CustomException('حدث خطأ ما، برجاء المحاولة لاحقًا');
      }
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.createUserWithEmailAndPassword: $e',
      );
      throw CustomException('حدث خطأ ما، برجاء المحاولة لاحقًا');
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
