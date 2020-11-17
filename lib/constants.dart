import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
  enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(39, 163, 183, 0.7), width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0))),
  focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(39, 163, 183, 0.7), width: 4.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0))),
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: kMentorXTeal, width: 2.0),
  ),
);

const kSendButtonTextStyle =
    TextStyle(color: kMentorXTeal, fontWeight: FontWeight.bold, fontSize: 18.0);

const kMentorXTeal = Color.fromRGBO(39, 163, 183, 0.7);
