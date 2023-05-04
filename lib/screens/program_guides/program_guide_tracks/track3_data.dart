import 'package:flutter/material.dart';

class Track3Data extends StatelessWidget {
  const Track3Data({
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
                '• Interview Prep 301',
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
                '• Networking 301',
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
                '• Becoming a Mentor',
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
                '• Mentor Shadow',
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
                '• Job Shadow',
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
