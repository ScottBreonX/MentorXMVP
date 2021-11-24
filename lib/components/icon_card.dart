import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

class IconCard extends StatelessWidget {
  const IconCard({
    Key key,
    @required this.cardColor,
    this.cardIconColor,
    @required this.cardTextColor,
    this.cardShadowColor,
    this.cardIcon,
    @required this.cardText,
    @required this.onTap,
    this.iconSize,
    this.textSize,
    this.boxHeight,
    this.boxWidth,
    this.imageAsset,
    this.borderColor,
    this.borderWidth,
    this.textSpacingHeight,
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
  final Image imageAsset;
  final double boxWidth;
  final Color borderColor;
  final double borderWidth;
  final double textSpacingHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: borderColor ?? kMentorXPrimary, width: borderWidth ?? 0),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                offset: Offset(2, 3),
                color: Colors.grey[700],
              ),
            ],
            color: cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imageAsset ??
                    Icon(
                      cardIcon,
                      color: cardIconColor,
                      size: iconSize ?? 80,
                    ),
                SizedBox(
                  height: textSpacingHeight ?? 5,
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
          ),
          height: boxHeight ?? 150,
          width: boxWidth ?? 150,
        ),
      ),
    );
  }
}
