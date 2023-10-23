import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

Future<bool> showAlertDialog(
  BuildContext context, {
  @required String title,
  @required String content,
  String cancelActionText,
  @required String defaultActionText,
}) {
  // if (!Platform.isIOS) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(title),
  //       content: Text(content),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.canPop(context),
  //           child: Text(
  //             defaultActionText,
  //           ),
  //         ),
  //         if (cancelActionText != null)
  //           TextButton(
  //             child: Text(cancelActionText),
  //             onPressed: () {
  //               Navigator.of(context, rootNavigator: true).pop();
  //             },
  //           ),
  //       ],
  //     ),
  //   );
  // }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: kMentorXPSecondary,
          fontSize: 20,
          fontFamily: 'Montserrat',
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 15,
          fontFamily: 'Montserrat',
        ),
      ),
      actions: [
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(
              cancelActionText,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontFamily: 'Montserrat',
              ),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            defaultActionText,
            style: TextStyle(
              color: kMentorXPSecondary,
              fontSize: 15,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
