import 'package:flutter/material.dart';

class GraduateDegrees401DataV1 extends StatelessWidget {
  const GraduateDegrees401DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'The decision to pursue a graduate degree depends on your individual circumstances, career aspirations, and personal goals.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Obtaining a graduate degree can offer several potential benefits, both in terms of career advancement and personal growth. Here are some common advantages of pursuing a graduate degree:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
