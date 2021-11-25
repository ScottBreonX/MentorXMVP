import 'package:flutter/material.dart';

class IconCircle extends StatelessWidget {
  const IconCircle({
    Key key,
    this.height,
    this.width,
    this.iconSize,
    this.iconType,
    this.circleColor,
    this.iconColor,
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
      decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor),
      child: Icon(
        iconType,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
