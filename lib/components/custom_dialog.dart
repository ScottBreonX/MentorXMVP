import 'package:flutter/material.dart';

import '../constants.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key key,
    @required this.title,
    @required this.descriptions,
    @required this.textLeft,
    @required this.textRight,
    @required this.leftOnPressed,
    @required this.rightOnPressed,
    this.titleFontSize,
    this.descriptionFontSize,
  });

  final String title;
  final double titleFontSize;
  final String descriptions;
  final double descriptionFontSize;
  final String textLeft;
  final String textRight;
  final Function leftOnPressed;
  final Function rightOnPressed;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: kMentorXBlack,
                width: 0.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                ),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: widget.titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(
                  fontSize: widget.descriptionFontSize,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    child: TextButton(
                        onPressed: widget.leftOnPressed,
                        child: Text(
                          widget.textLeft,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: widget.rightOnPressed,
                        child: Text(
                          widget.textRight,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ), // bottom part
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.10),
              radius: Constants.avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(Constants.avatarRadius),
                ),
                child: Image.asset(
                  "assets/images/MentorPink.png",
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
        ), // top part
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
}
