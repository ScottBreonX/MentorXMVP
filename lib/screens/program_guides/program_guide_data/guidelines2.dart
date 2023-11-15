import 'package:flutter/material.dart';

class Guidelines2 extends StatelessWidget {
  const Guidelines2({
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
            text: 'Confidentiality: ',
            style: TextStyle(
              color: bodyTextColor ?? Colors.white,
              fontSize: 20,
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
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: RichText(
            text: TextSpan(
              text: 'Respect: ',
              style: TextStyle(
                color: bodyTextColor ?? Colors.white,
                fontSize: 20,
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
      ],
    );
  }
}
