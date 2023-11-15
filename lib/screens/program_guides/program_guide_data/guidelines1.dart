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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Congratulations on joining a MentorUp mentorship program!',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: RichText(
            text: TextSpan(
              text: '',
              style: TextStyle(
                color: bodyTextColor ?? Colors.white,
                fontSize: 20,
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
        ),
      ],
    );
  }
}
