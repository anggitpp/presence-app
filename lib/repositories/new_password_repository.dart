import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/custom_error.dart';

class NewPasswordRepository {
  final FirebaseFirestore firebaseFirestore;
  final auth.FirebaseAuth firebaseAuth;
  NewPasswordRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  Future<void> changePassword(String password) async {
    try {
      String email = firebaseAuth.currentUser!.email!;

      await firebaseAuth.currentUser!.updatePassword(password);

      await firebaseAuth.signOut();

      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on auth.FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}
