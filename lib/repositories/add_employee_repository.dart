import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:presence_app/config/constants.dart';

import '../../../models/custom_error.dart';

class AddEmployeRepository {
  final FirebaseFirestore firebaseFirestore;
  final auth.FirebaseAuth firebaseAuth;
  AddEmployeRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  Future<void> addEmployee(
      {required String nip,
      required String name,
      required String email}) async {
    String errorMessage = '';

    try {
      auth.UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: "password");
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        await empRef.doc(uid).set({
          "nip": nip,
          "name": name,
          "email": email,
          "uid": uid,
          "createdAt": DateTime.now().toIso8601String(),
        });
      }
      print(userCredential);
    } on auth.FirebaseAuthException catch (e) {
      errorMessage = e.message!;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      throw CustomError(code: e.code, message: errorMessage, plugin: e.plugin);
    } catch (e) {
      CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error');
    }
  }
}
