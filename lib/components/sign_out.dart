import 'package:flutter/material.dart';
import 'alert_dialog.dart';
import 'package:mentorx_mvp/screens/login/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;

Future<void> confirmSignOut(BuildContext context) async {
  final didRequestSignOut = await showAlertDialog(
    context,
    title: "Log Out",
    content: "Are you sure you want to log out?",
    defaultActionText: "Yes",
    cancelActionText: "No",
  );
  if (didRequestSignOut == true) {
    _auth.signOut();
    Navigator.popAndPushNamed(context, WelcomeScreen.id);
  }
}
