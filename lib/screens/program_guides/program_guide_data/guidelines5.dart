import 'package:flutter/material.dart';

class Guidelines5 extends StatelessWidget {
  const Guidelines5({
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
            text: 'Termination: ',
            style: TextStyle(
              color: bodyTextColor ?? Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Either the mentor or mentee may terminate the mentorship program at any time if it is no longer serving its purpose or if the relationship has become untenable. A notice period may be required to ensure a smooth transition.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
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
                      'These rules are not exhaustive and may be adapted to suit the needs of the mentorship program. The most important thing is that both parties are committed to the program and work towards achieving the agreed-upon goals.',
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
