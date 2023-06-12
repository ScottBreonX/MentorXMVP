import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

class Networking301DataV1 extends StatelessWidget {
  const Networking301DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Networking requires continual upkeep, but yields many opportunities',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Text(
            'Start by identifying your target companies and industries.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            '\u2022 What kind of company do you want to work for?',
            style: TextStyle(
              color: kMentorXPAccentMed,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            '\u2022 What industry are you interested in?',
            style: TextStyle(
              color: kMentorXPAccentMed,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Text(
            'Once you know this, you can start to identify people who work at those companies or in those industries.',
            style: TextStyle(
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
