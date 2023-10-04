import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

Container miniProgressIndicator() {
  return Container(
    height: 100,
    color: Colors.transparent,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/MXPDark.png',
          fit: BoxFit.cover,
          height: 20,
          width: 20,
        ),
        SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            backgroundColor: kMentorXPSecondary,
            strokeWidth: 10,
          ),
        ),
      ],
    ),
  );
}

Container circularProgress(Color backgroundColor) {
  return Container(
    // color: backgroundColor.withOpacity(0.5),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/MXPDark.png',
          fit: BoxFit.cover,
          height: 150,
          width: 150,
        ),
        SizedBox(
          height: 200,
          width: 200,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(kMentorXPPrimary),
            backgroundColor: kMentorXPAccentMed,
            strokeWidth: 10,
          ),
        ),
      ],
    ),
  );
}
