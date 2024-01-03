import 'package:flutter/material.dart';

import '../../../../../constants.dart';

class Networking101DataV4 extends StatelessWidget {
  const Networking101DataV4({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            'A great way to begin building your network is by '
            'creating a Linkedin account.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            'Users can highlight their work experience, skills, '
            'and education as well as connect with other industry '
            'professionals.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            'If you don\’t have a headshot for your profile, '
            'coordinate with your mentor to have one taken.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            'Take a few moments to review each other’s Linkedin profiles.',
            style: TextStyle(
              color: kMentorXPPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
