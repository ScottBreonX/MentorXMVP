import 'package:flutter/material.dart';

class Track2Data extends StatelessWidget {
  const Track2Data({
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
                color: Colors.white,
                fontSize: fontSize ?? 18,
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
                'College Year 1-3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize ?? 18,
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
              color: Colors.white,
              fontSize: fontSize ?? 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'This track advances on track 1 with more focus on interview prep, mock interviews and taking a tour of a company. This is for someone who has a good idea of the career they want to pursue.',
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
                  fontSize: fontSize ?? 18,
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
                fontSize: fontSize ?? 18,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                '• Interview Prep 201',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize ?? 18,
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
                '• Networking 201',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize ?? 18,
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
                '• Mock Interview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize ?? 18,
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
                '• Company Networking',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize ?? 18,
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
                '• Company Tour',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize ?? 18,
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
