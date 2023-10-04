import 'package:flutter/material.dart';

import '../constants.dart';

class IconCircleSingle extends StatelessWidget {
  const IconCircleSingle({
    this.onPressedFunction,
    this.cardIcon,
    this.cardIconSize,
    this.cardHeight,
    this.cardWidth,
    this.cardIconColor,
    this.circleRadius,
  });

  final Function onPressedFunction;
  final IconData cardIcon;
  final double cardIconSize;
  final double cardHeight;
  final double cardWidth;
  final Color cardIconColor;
  final double circleRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: onPressedFunction,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(circleRadius ?? 100),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circleRadius ?? 100),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  cardIcon ?? Icons.add,
                  color: cardIconColor ?? kMentorXPSecondary,
                  size: cardIconSize ?? 40,
                ),
              ],
            ),
            height: cardHeight ?? 110,
            width: cardWidth ?? 110,
          ),
        ),
      ),
    );
  }
}
