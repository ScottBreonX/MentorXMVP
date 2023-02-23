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
  labelStyle: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
  hintStyle: TextStyle(color: Colors.white70, fontFamily: 'Montserrat'),
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

//Color palette themes
const kMentorXPPrimary = Color.fromRGBO(38, 70, 83, 1);
const kMentorXPSecondary = Color.fromRGBO(42, 157, 143, 1);
const kMentorXPAccentLight = Color.fromRGBO(233, 196, 106, 1);
const kMentorXPAccentMed = Color.fromRGBO(244, 162, 97, 1);
const kMentorXPAccentDark = Color.fromRGBO(231, 111, 81, 1);
const kUMichBlue = Color.fromRGBO(20, 24, 70, 1.0);
const kDrawerItems = Colors.white;

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
