import 'package:flutter/material.dart';

class ProfileImageCircle extends StatefulWidget {
  const ProfileImageCircle({
    @required this.iconSize,
    @required this.circleSize,
    this.profileImage,
    this.circleColor,
    this.iconColor = Colors.white,
    this.onTap,
  });

  final double iconSize;
  final double circleSize;
  final Color circleColor;
  final Color iconColor;
  final String profileImage;
  final Function onTap;

  @override
  State<ProfileImageCircle> createState() => _ProfileImageCircleState();
}

class _ProfileImageCircleState extends State<ProfileImageCircle> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.circleSize * 2,
      width: widget.circleSize * 2,
      child: RawMaterialButton(
        onPressed: widget.onTap,
        fillColor: widget.circleColor ?? Theme.of(context).canvasColor,
        child:
            // CircleAvatar(backgroundImage: NetworkImage(widget.profileImage)),

            Icon(
          Icons.person,
          color: widget.iconColor,
          size: widget.iconSize,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
    );
  }
}
