import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

Container circularProgress() {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
        backgroundColor: kMentorXPSecondary,
      ));
}

Container circularProgressBlue() {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
        backgroundColor: kMentorXPSecondary,
      ));
}
