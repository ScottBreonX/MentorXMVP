import 'package:flutter/material.dart';

class ProfileImageCircle extends StatelessWidget {
  const ProfileImageCircle({
    @required this.iconSize,
    @required this.circleSize,
    this.circleColor,
    this.iconColor = Colors.white,
    this.onTap,
  });

  final double iconSize;
  final double circleSize;
  final Color circleColor;
  final Color iconColor;
  final Function onTap;

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
        onPressed: onTap,
        fillColor: circleColor ?? Theme.of(context).canvasColor,
        child: Icon(
          Icons.person,
          color: iconColor,
          size: iconSize,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
    );
  }
}
