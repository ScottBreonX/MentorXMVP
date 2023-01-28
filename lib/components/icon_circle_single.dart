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
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(1.0),
              width: 0,
            ),
            borderRadius: BorderRadius.circular(circleRadius ?? 100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[600],
                blurRadius: 5,
                offset: Offset(0, 7),
              ),
            ],
            color: Colors.white,
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
    );
  }
}
