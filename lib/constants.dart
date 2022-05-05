import 'package:flutter/material.dart';

//Text field decorations
const kTextFieldDecoration = InputDecoration(
//  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.black54),
  labelStyle: TextStyle(color: Colors.black54),
  fillColor: Colors.white24,
  filled: true,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0))),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 4.0, color: Colors.blue),
      borderRadius: BorderRadius.all(Radius.circular(10.0))),
);

const kTextFieldDecorationLight = InputDecoration(
  labelText: 'Enter a value',
  labelStyle: TextStyle(color: Colors.white),
  hintStyle: TextStyle(color: Colors.white70),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 4.0),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 4.0),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 4.0),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
);

//Message text field decorations
const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.black),
    bottom: BorderSide(color: Colors.black),
    right: BorderSide(color: Colors.black),
    left: BorderSide(color: Colors.black),
  ),
  borderRadius: BorderRadius.all(
    Radius.circular(10),
  ),
);

//Color pallette themes
const kMentorXPrimary = Colors.blue;
const kUMichBlue = Color.fromRGBO(20, 24, 70, 1.0);
const kDrawerItems = Colors.white;

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
