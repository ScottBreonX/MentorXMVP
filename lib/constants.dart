import 'package:flutter/material.dart';

const kTextFieldDecorationDark = InputDecoration(
  labelText: 'Enter a value',
  labelStyle: TextStyle(color: Colors.white),
  hintStyle: TextStyle(color: Colors.white60),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kMentorXTeal, width: 4.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0))),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 4.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0))),
);

const kTextFieldDecorationLight = InputDecoration(
  labelText: 'Enter a value',
  labelStyle: TextStyle(color: kMentorXTeal),
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kMentorXTeal, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0))),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kMentorXTeal, width: 4.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0))),
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

const kInactiveSendButtonTextStyle =
    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18.0);

const kMentorXTeal = Color.fromRGBO(4, 52, 156, 1.0);
const kDrawerItems = Colors.white;
//Color.fromRGBO(4, 52, 106, 1.0)
//Color.fromRGBO(56, 142, 137, 1.0);

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
