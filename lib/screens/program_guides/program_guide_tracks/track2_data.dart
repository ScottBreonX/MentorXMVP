import 'package:flutter/material.dart';

class Track2Data extends StatelessWidget {
  const Track2Data({
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
                '• Interview Prep 201',
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
                '• Networking 201',
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
                '• Mock Interview',
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
                '• Company Networking',
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
                '• Company Tour',
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
