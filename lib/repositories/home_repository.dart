import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/custom_error.dart';

class HomeRepository {
  final FirebaseFirestore firebaseFirestore;
  final auth.FirebaseAuth firebaseAuth;
  HomeRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
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
