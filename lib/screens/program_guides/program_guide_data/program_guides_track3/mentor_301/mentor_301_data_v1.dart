import 'package:flutter/material.dart';

class Mentor301DataV1 extends StatelessWidget {
  const Mentor301DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'A mentor is a person who provides guidance, support, and encouragement to a mentee.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Mentors can help mentees with a variety of things, such as:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\u2022 Setting and achieving goals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                '\u2022 Developing skills and knowledge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                '\u2022 Networking with other professionals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                '\u2022 Navigating career challenges',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                '\u2022 Building confidence and self-esteem',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                '\u2022 Providing emotional support',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
