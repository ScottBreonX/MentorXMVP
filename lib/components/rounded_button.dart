import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {this.title,
      this.buttonColor,
      this.fontColor,
      @required this.onPressed,
      @required this.minWidth});

  final Color buttonColor;
  final String title;
  final Color fontColor;
  final Function onPressed;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: minWidth,
          height: 50.0,
          child: Text(
            title,
            style: TextStyle(
              color: fontColor,
            ),
          ),
        ),
      ),
    );
  }
}
