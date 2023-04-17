import 'package:flutter/material.dart';

class MajorCareer101DataV4 extends StatelessWidget {
  const MajorCareer101DataV4({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            'While you brainstorm majors to pursue, '
            'it is important to remember that this does '
            'not have to be a permanent decision. Many students '
            'change majors multiple times while obtaining their degree.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            'Looking into course requirements for '
            'each major can be a great place to start. '
            'If the courses sound appealing and aligned with '
            'your expertise, you might be on the right path.',
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
