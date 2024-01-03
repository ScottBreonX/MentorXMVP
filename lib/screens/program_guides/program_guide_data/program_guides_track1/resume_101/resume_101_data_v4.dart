import 'package:flutter/material.dart';

class Resume101DataV4 extends StatelessWidget {
  const Resume101DataV4({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Take a few minutes to swap resumes and discuss feedback.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            'Start with positive feedback by acknowledging the '
            'strengths of each resume.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            'Offer constructive criticism on what could be improved, and include specific examples. ',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            'Consider the industry and job requirements throughout the session.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
