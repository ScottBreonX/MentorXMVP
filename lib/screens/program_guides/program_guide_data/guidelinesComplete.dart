import 'package:flutter/material.dart';

class GuidelinesComplete extends StatelessWidget {
  const GuidelinesComplete({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30),
          child: Text(
            'Tap the below button to complete and acknowledge Program Guidelines',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
