import 'package:flutter/material.dart';

class Coaching301DataV1 extends StatelessWidget {
  const Coaching301DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'This session will teach you how to listen while coaching someone and helping them to solve issues. The goal is not to give answers, but to help the person you are coaching finding their own answers. Find the root cause of the issues and come up with an action item to solve the problem. Both mentee and mentor will take turns taking the role of coach.',
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
            'Understand the value of coaching & learn a coaching / problem-solving model',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
