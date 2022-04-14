import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:presence_app/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final pref = await SharedPreferences.getInstance();
    String? userPassword = pref.getString('userPassword');
    String? userEmail = pref.getString('userEmail');
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

        await userCredential.user!.sendEmailVerification();

        //LOGOUT USER YANG BARU DI BUAT
        await firebaseAuth.signOut();

        //LOGIN ULANG SI PEMBUAT
        await firebaseAuth.signInWithEmailAndPassword(
            email: userEmail!, password: userPassword!);
      }
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
