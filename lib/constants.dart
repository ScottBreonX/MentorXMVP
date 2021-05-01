import 'package:flutter/material.dart';

const kTextFieldDecorationDark = InputDecoration(
//  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.white60),
  fillColor: Colors.white24,
  filled: true,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white60, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0))),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kMentorXSecondary, width: 3.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0))),
);

const kTextFieldDecorationLight = InputDecoration(
  labelText: 'Enter a value',
  labelStyle: TextStyle(color: kMentorXPrimary),
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0))),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kMentorXPrimary, width: 4.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0))),
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: kMentorXPrimary, width: 2.0),
  ),
);

const kSendButtonTextStyle = TextStyle(
    color: kMentorXPrimary, fontWeight: FontWeight.bold, fontSize: 18.0);

const kInactiveSendButtonTextStyle =
    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18.0);

const kMentorXPrimary = Color.fromRGBO(51, 173, 251, 1.0);
const kMentorXMenu = Color.fromRGBO(251, 251, 251, 1.0);
const kMentorXSecondary = Color.fromRGBO(171, 237, 0, 1.0);
const kMentorXDark = Color.fromRGBO(40, 40, 40, 1.0);
const kMentorXBlack = Color.fromRGBO(20, 20, 20, 1.0);
const kDrawerItems = Colors.white;
//Color.fromRGBO(4, 52, 106, 1.0)
//Color.fromRGBO(56, 142, 137, 1.0);

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

//*** Primary color:
//
//shade 0 = #095FA1 = rgb(  9, 95,161) = rgba(  9, 95,161,1) = rgb0(0.035,0.373,0.631)
//shade 1 = #4A8ABC = rgb( 74,138,188) = rgba( 74,138,188,1) = rgb0(0.29,0.541,0.737)
//shade 2 = #2875B0 = rgb( 40,117,176) = rgba( 40,117,176,1) = rgb0(0.157,0.459,0.69)
//shade 3 = #074B7F = rgb(  7, 75,127) = rgba(  7, 75,127,1) = rgb0(0.027,0.294,0.498)
//shade 4 = #043A63 = rgb(  4, 58, 99) = rgba(  4, 58, 99,1) = rgb0(0.016,0.227,0.388)
//
//*** Secondary color (1):
//
//shade 0 = #ABED00 = rgb(171,237,  0) = rgba(171,237,  0,1) = rgb0(0.671,0.929,0)
//shade 1 = #C8F555 = rgb(200,245, 85) = rgba(200,245, 85,1) = rgb0(0.784,0.961,0.333)
//shade 2 = #BBF32A = rgb(187,243, 42) = rgba(187,243, 42,1) = rgb0(0.733,0.953,0.165)
//shade 3 = #87BB00 = rgb(135,187,  0) = rgba(135,187,  0,1) = rgb0(0.529,0.733,0)
//shade 4 = #6A9200 = rgb(106,146,  0) = rgba(106,146,  0,1) = rgb0(0.416,0.573,0)
//
//*** Secondary color (2):
//
//shade 0 = #7C06A6 = rgb(124,  6,166) = rgba(124,  6,166,1) = rgb0(0.486,0.024,0.651)
//shade 1 = #A048C0 = rgb(160, 72,192) = rgba(160, 72,192,1) = rgb0(0.627,0.282,0.753)
//shade 2 = #8F25B4 = rgb(143, 37,180) = rgba(143, 37,180,1) = rgb0(0.561,0.145,0.706)
//shade 3 = #620483 = rgb( 98,  4,131) = rgba( 98,  4,131,1) = rgb0(0.384,0.016,0.514)
//shade 4 = #4C0366 = rgb( 76,  3,102) = rgba( 76,  3,102,1) = rgb0(0.298,0.012,0.4)
