import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  labelText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kMentorXTeal, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0))),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kMentorXTeal, width: 4.0),
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

const kMentorXTeal = Color.fromRGBO(56, 142, 137, 1.0);

//Color.fromRGBO(56, 142, 137, 1.0);
