import 'package:flutter/material.dart';

import '../constants.dart';

class IconCircle extends StatelessWidget {
  const IconCircle({
    Key key,
    @required this.height,
    @required this.width,
    @required this.iconSize,
    @required this.iconType,
    @required this.circleColor,
    @required this.iconColor,
    this.shadowColor,
  }) : super(key: key);

  final double height;
  final double width;
  final double iconSize;
  final IconData iconType;
  final Color circleColor;
  final Color iconColor;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: circleColor, boxShadow: [
        BoxShadow(
          color: shadowColor ?? kMentorXBlack,
          offset: Offset(2, 3),
          blurRadius: 2,
        )
      ]),
      child: Icon(
        iconType,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
