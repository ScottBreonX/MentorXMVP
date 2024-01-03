import 'package:flutter/material.dart';

class MenteeResponsibilities1 extends StatelessWidget {
  const MenteeResponsibilities1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: '',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'The role of a mentee is to actively participate in the mentoring relationship and take responsibility for your own personal and professional development. Some key responsibilities of a mentee include:',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: RichText(
            text: TextSpan(
              text: 'Set goals and objectives: ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Have clear goals and objectives to achieve through the mentoring relationship. These goals can be career-oriented, personal, or related to skill development.',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
