import 'package:flutter/material.dart';

class Track4Data extends StatelessWidget {
  const Track4Data({
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
                'College Year 2-4',
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
                    'Adds new soft skills to your toolkit and helps you identify additional skills that will help make you attractive in the job market.',
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
                '• Emotional Intelligence',
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
                '• Diversity & Inclusion',
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
                '• Skill Development',
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
                '• Negotiation',
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
                '• Shared Learnings',
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
