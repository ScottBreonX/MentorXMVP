import 'package:flutter/material.dart';

class Track1Data extends StatelessWidget {
  const Track1Data({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'What this track focuses on: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Geared toward anyone looking to start their journey of finding their career path. Build your first Resume, create a LinkedIn profile and explore different majors and companies.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                'Session Guides: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '• Introductions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                '• Resume 101',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                '• Networking 101',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                '• Career Exploration',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                '• Company targeting',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                '• Interview Prep 101',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
