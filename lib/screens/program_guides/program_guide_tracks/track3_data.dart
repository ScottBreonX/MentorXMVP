import 'package:flutter/material.dart';

class Track3Data extends StatelessWidget {
  const Track3Data({
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
                'College Year 2-3',
                style: TextStyle(
                  color: Colors.black54,
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
              color: Colors.black54,
              fontSize: fontSize ?? 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Builds on previous tracks and sharpens skills of professional development. This is for someone who is looking to participate in recruiting activities.',
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
                color: Colors.black54,
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
                '• Interview Prep 301',
                style: TextStyle(
                  color: Colors.black54,
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
                '• Networking 301',
                style: TextStyle(
                  color: Colors.black54,
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
                '• Becoming a Mentor',
                style: TextStyle(
                  color: Colors.black54,
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
                '• Mentor Shadow',
                style: TextStyle(
                  color: Colors.black54,
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
                '• Job Shadow',
                style: TextStyle(
                  color: Colors.black54,
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
