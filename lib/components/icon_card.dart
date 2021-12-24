import 'package:flutter/material.dart';

class IconCard extends StatelessWidget {
  const IconCard({
    Key key,
    this.cardColor,
    this.cardIconColor,
    this.cardTextColor,
    this.cardShadowColor,
    this.cardIcon,
    this.cardText,
    this.cardGradient,
    this.onTap,
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
  final Gradient cardGradient;
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
            gradient: cardGradient,
            border: Border.all(
              color: borderColor != null
                  ? borderColor
                  : Colors.white.withOpacity(1.0),
              width: borderWidth != null ? borderWidth : 0,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[700],
                blurRadius: 5,
                offset: Offset(5, 5),
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
                      cardIcon ?? Icons.person,
                      color: cardIconColor,
                      size: iconSize ?? 80,
                    ),
                SizedBox(
                  height: textSpacingHeight ?? 5,
                ),
                Text(
                  cardText ?? '',
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
