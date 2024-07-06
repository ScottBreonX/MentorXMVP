import 'package:flutter/material.dart';

class Guidelines1 extends StatelessWidget {
  const Guidelines1({
    this.bodyTextColor,
    Key key,
  }) : super(key: key);

  final Color bodyTextColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: '',
            style: TextStyle(
              color: bodyTextColor ?? Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Please read through the following guidelines to help you set expectations and make the most out of your experience.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RichText(
            text: TextSpan(
              text: 'Confidentiality: ',
              style: TextStyle(
                color: bodyTextColor ?? Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                  'All discussions between the mentor and mentee should be kept confidential unless agreed upon otherwise.',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RichText(
            text: TextSpan(
              text: 'Respect: ',
              style: TextStyle(
                color: bodyTextColor ?? Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                  'Both the mentor and mentee should show mutual respect towards each other. Any disrespectful behavior or language will not be tolerated.',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RichText(
            text: TextSpan(
              text: 'Commitment: ',
              style: TextStyle(
                color: bodyTextColor ?? Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                  'Both the mentor and mentee should commit to regular meetings and communication. The frequency and format of meetings can be decided mutually.',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RichText(
            text: TextSpan(
              text: 'Goals: ',
              style: TextStyle(
                color: bodyTextColor ?? Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                  'The mentorship program should have clear goals and objectives that are agreed upon by both parties. These goals should be reviewed periodically and adjusted as needed.',
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
