import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/login_screen.dart';

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Log In"),
    onPressed: () {
      Navigator.popAndPushNamed(context, LoginScreen.id);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Please log in"),
    content: Text("An account with this email already exists. Please log in."),
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
