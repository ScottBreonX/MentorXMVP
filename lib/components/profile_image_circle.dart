import 'package:flutter/material.dart';

import '../constants.dart';

class ProfileImageCircle extends StatelessWidget {
  const ProfileImageCircle(
      {@required this.iconSize,
      this.circleColor = kMentorXPrimary,
      this.iconColor = Colors.white,
      @required this.circleSize});

  final double iconSize;
  final double circleSize;
  final Color circleColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundColor: circleColor,
        radius: circleSize ?? 50,
        child: CircleAvatar(
          backgroundColor: circleColor,
          radius: 45,
          child: Icon(
            Icons.person,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
