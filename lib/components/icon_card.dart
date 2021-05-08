import 'package:flutter/material.dart';

class IconCard extends StatelessWidget {
  const IconCard({
    Key key,
    @required this.cardColor,
    @required this.cardIconColor,
    @required this.cardTextColor,
    @required this.cardShadowColor,
    @required this.cardIcon,
    @required this.cardText,
    @required this.onTap,
    this.iconSize,
    this.textSize,
    this.boxHeight,
    this.boxWidth,
  }) : super(key: key);

  final Color cardColor;
  final Color cardIconColor;
  final Color cardTextColor;
  final Color cardShadowColor;
  final IconData cardIcon;
  final String cardText;
  final Function onTap;
  final double iconSize;
  final double textSize;
  final double boxHeight;
  final double boxWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                offset: Offset(2, 3),
                color: cardShadowColor,
              ),
            ],
            color: cardColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                cardIcon,
                color: cardIconColor,
                size: iconSize ?? 80,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                cardText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cardTextColor,
                  fontSize: textSize ?? 20,
                ),
              )
            ],
          ),
          height: boxHeight ?? 150,
          width: boxWidth ?? 150,
        ),
      ),
    );
  }
}
