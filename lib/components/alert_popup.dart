import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/login_screen.dart';
import 'package:mentorx_mvp/screens/registration_screen.dart';

showLoginError(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Try Again"),
    onPressed: () {
      Navigator.popAndPushNamed(context, LoginScreen.id); // dismiss dialog
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Register"),
    onPressed: () {
      Navigator.popAndPushNamed(context, RegistrationScreen.id);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Incorrect Email or Password"),
    content: Text(
        "Incorrect email or password entered. Try again or register as new user."),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
