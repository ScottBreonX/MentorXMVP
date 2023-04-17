import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

class Introductions1 extends StatelessWidget {
  const Introductions1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'The first meeting between a mentor and mentee is an '
          'important opportunity to establish rapport, '
          'set expectations, and get to know each other. ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            'Swipe to see some tips on how to make the most of this first meeting.',
            style: TextStyle(
              color: kMentorXPAccentMed,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
