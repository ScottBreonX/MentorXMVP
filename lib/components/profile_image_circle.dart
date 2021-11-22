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

  // replaced the code below; NK - 11/22/21
  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //     ),
  //     child: CircleAvatar(
  //       backgroundColor: circleColor,
  //       radius: circleSize ?? 50,
  //       child: CircleAvatar(
  //         backgroundColor: circleColor,
  //         radius: 45,
  //         child: Icon(
  //           Icons.person,
  //           color: iconColor,
  //           size: iconSize,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return SizedBox(
      height: circleSize * 2,
      width: circleSize * 2,
      child: RawMaterialButton(
        onPressed: () {},
        elevation: 2.0,
        fillColor: Colors.white,
        child: Icon(
          Icons.person_outlined,
          color: Colors.blue,
          size: iconSize,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
    );
  }
}
