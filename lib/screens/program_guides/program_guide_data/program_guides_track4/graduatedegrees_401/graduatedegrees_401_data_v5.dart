import 'package:flutter/material.dart';

class GraduateDegrees401DataV5 extends StatelessWidget {
  const GraduateDegrees401DataV5({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RichText(
            text: TextSpan(
              text: '4. Personal Fulfillment and Achievement: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'For many individuals, earning a graduate degree is a significant personal accomplishment and source of pride. It signifies your commitment to lifelong learning, intellectual curiosity, and the pursuit of excellence.',
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
