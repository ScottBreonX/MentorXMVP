import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    @required this.title,
    @required this.buttonColor,
    @required this.fontColor,
    @required this.onPressed,
    this.minWidth,
    this.borderRadius = 30.0,
    this.fontSize,
  });

  final Color buttonColor;
  final String title;
  final Color fontColor;
  final double fontSize;
  final Function onPressed;
  final double minWidth;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: minWidth,
          height: 50.0,
          child: Text(
            title,
            style: TextStyle(
              color: fontColor,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
