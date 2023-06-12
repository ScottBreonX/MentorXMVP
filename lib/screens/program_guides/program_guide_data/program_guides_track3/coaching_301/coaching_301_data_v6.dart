import 'package:flutter/material.dart';

class Coaching301DataV6 extends StatelessWidget {
  const Coaching301DataV6({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Take turns switching roles of coach and coachee to improve the skill of coach and find personal solutions. Be sure to take notes and provide feedback between coaching sessions.',
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
            'Additionally you can pair up with another mentorship group and practice coaching to get new perspectives.',
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
