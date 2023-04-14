import 'package:flutter/material.dart';

class Resume101DataV6 extends StatelessWidget {
  const Resume101DataV6({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 00.0),
          child: Text(
            'A few examples include leadership, communication, problem-solving, '
            'and adaptability skills.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            'Reflect on experiences you’ve had developing these skills that might '
            'not be currently represented on your resume.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 50),
          child: Text(
            'Make a list of three skills that you want to further develop.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
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
