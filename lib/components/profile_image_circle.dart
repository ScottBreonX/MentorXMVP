import 'package:flutter/material.dart';

import '../constants.dart';

class ProfileImageCircle extends StatelessWidget {
  const ProfileImageCircle(
      {@required this.circleSize,
      this.circleColor = kMentorXTeal,
      this.iconColor = Colors.white});

  final double circleSize;
  final Color circleColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(2, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: circleColor,
        radius: 50,
        child: CircleAvatar(
          backgroundColor: circleColor,
          radius: 45,
          child: Icon(
            Icons.person,
            color: iconColor,
            size: circleSize,
          ),
        ),
      ),
    );
  }
}
