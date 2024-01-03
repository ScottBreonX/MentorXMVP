import 'package:flutter/material.dart';

class Track1Data extends StatelessWidget {
  const Track1Data({
    Key key,
    this.fontSize,
  }) : super(key: key);

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Recommended for: ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: fontSize ?? 17,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: [
              Text(
                'College Year 1-2',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: fontSize ?? 17,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'What this track focuses on: ',
            style: TextStyle(
              color: Colors.black54,
              fontSize: fontSize ?? 17,
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
                  color: Colors.black54,
                  fontSize: fontSize ?? 17,
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
                color: Colors.black54,
                fontSize: fontSize ?? 17,
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
                  color: Colors.black54,
                  fontSize: fontSize ?? 17,
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
                  color: Colors.black54,
                  fontSize: fontSize ?? 17,
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
                  color: Colors.black54,
                  fontSize: fontSize ?? 17,
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
                  color: Colors.black54,
                  fontSize: fontSize ?? 17,
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
                  color: Colors.black54,
                  fontSize: fontSize ?? 17,
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
