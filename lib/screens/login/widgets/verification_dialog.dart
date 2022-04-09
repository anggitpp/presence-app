import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presence_app/blocs/blocs.dart';

void verificationDialog(BuildContext context, UserCredential user) {
  String title = 'Unverified';
  String message =
      'Kamu belum verifikasi akun ini akun ini, segera lakukan verifikasi di email kamu.';
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              onPressed: () {
                context
                    .read<LoginBloc>()
                    .add(VerificationEmailEvent(userCredential: user));

                Navigator.pop(context);
              },
              child: const Text("Kirim Ulang"),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<LoginBloc>()
                      .add(VerificationEmailEvent(userCredential: user));
                },
                child: const Text("Kirim Ulang"),
              ),
            ],
          );
        });
  }
}
