import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/custom_error.dart';

class LoginRepository {
  final FirebaseFirestore firebaseFirestore;
  final auth.FirebaseAuth firebaseAuth;
  LoginRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  Future<auth.UserCredential> login(
      {required String email, required String password}) async {
    String errorMessage = '';

    try {
      auth.UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on auth.FirebaseAuthException catch (e) {
      errorMessage = e.message!;

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }
      throw CustomError(code: e.code, message: errorMessage, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> verificationEmail(
      {required auth.UserCredential userCredential}) async {
    try {
      await userCredential.user!.sendEmailVerification();
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}
