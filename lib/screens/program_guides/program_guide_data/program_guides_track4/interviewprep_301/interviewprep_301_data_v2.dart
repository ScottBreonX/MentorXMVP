import 'package:flutter/material.dart';

class InterviewPrep301DataV2 extends StatelessWidget {
  const InterviewPrep301DataV2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'An on-site interview is the final stage of the hiring process for many jobs. It is an opportunity for you to meet with the hiring manager and other members of the team, and to learn more about the company and the position.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'They typically last for a few hours and involve a series of interviews with different people. You may be asked a variety of questions about your skills, experience, and qualifications.',
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
