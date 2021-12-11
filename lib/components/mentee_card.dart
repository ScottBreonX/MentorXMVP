import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import '../constants.dart';

class MenteeCard extends StatelessWidget {
  myUser user;
  final Color cardColor;
  final Color borderColor;
  final Color cardTextColor;
  final Function onTap;
  final double primaryTextSize;
  final double secondaryTextSize;
  final double boxHeight;
  final double boxWidth;

  MenteeCard({
    Key key,
    @required this.user,
    this.cardTextColor,
    this.borderColor,
    this.onTap,
    this.cardColor,
    this.primaryTextSize,
    this.secondaryTextSize,
    this.boxHeight,
    this.boxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? kMentorXPrimary, width: 8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                offset: Offset(2, 3),
                color: Colors.grey[700],
              ),
            ],
            color: cardColor ?? Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // image placeholder
              ProfileImageCircle(
                iconSize: 125,
                iconColor: Colors.blue,
                circleSize: 75,
                circleColor: Colors.grey[300],
              ),
              SizedBox(height: 5.0),
              SizedBox(
                height: 5,
              ),
              Text(
                '${user.firstName} ${user.lastName}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cardTextColor ?? Colors.black,
                  fontSize: primaryTextSize ?? 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${user.major} - ${user.yearInSchool}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cardTextColor ?? Colors.black,
                  fontSize: secondaryTextSize ?? 15,
                ),
              ),
            ],
          ),
          height: boxHeight ?? 150,
          width: boxWidth ?? 450,
        ),
      ),
    );
  }
}
