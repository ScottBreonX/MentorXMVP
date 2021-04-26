import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Future<bool> showAlertDialog(
  BuildContext context, {
  @required String title,
  @required String content,
  String cancelActionText,
  @required String defaultActionText,
}) {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.canPop(context),
            child: Text(
              defaultActionText,
            ),
          ),
          if (cancelActionText != null)
            TextButton(
              child: Text(cancelActionText),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            defaultActionText,
          ),
        ),
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
      ],
    ),
  );
}
