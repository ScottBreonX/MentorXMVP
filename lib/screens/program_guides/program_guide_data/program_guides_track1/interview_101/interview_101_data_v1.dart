import 'package:flutter/material.dart';

class Interview101DataV1 extends StatelessWidget {
  const Interview101DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            'Job interviews are an essential part of the recruitment process for both employers and candidates.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            'As an interviewee, this is your opportunity to showcase your skills and stand out from other applicants. For the employer, this is a chance to gather additional information that they might not have seen on a resume or application.',
            style: TextStyle(
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
