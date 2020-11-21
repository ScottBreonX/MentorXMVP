import 'package:flutter/material.dart';

class AuthenticationAlert extends StatelessWidget {
  AuthenticationAlert({@required this.title, @required this.content});

  final Text title;
  final Text content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        FlatButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
