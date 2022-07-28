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
    this.borderColor,
    this.borderWidth,
    this.fontWeight,
    this.prefixIcon,
    this.textAlignment,
  });

  final Color buttonColor;
  final String title;
  final Color fontColor;
  final double fontSize;
  final Function onPressed;
  final double minWidth;
  final double borderRadius;
  final borderColor;
  final borderWidth;
  final FontWeight fontWeight;
  final Icon prefixIcon;
  final MainAxisAlignment textAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor != null ? borderColor : Colors.transparent,
              width: borderWidth != null ? borderWidth * 1.0 : 0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          onPressed: onPressed,
          minWidth: minWidth,
          height: 50.0,
          child: Row(
            mainAxisAlignment: textAlignment ?? MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: prefixIcon ?? Text(''),
              ),
              Text(
                title,
                style: TextStyle(
                  color: fontColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
