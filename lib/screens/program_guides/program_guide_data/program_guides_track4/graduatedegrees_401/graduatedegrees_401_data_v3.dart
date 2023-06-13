import 'package:flutter/material.dart';

class GraduateDegrees401DataV3 extends StatelessWidget {
  const GraduateDegrees401DataV3({
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
              text: '2. Credibility & Recognition: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'A graduate degree can provide credibility and professional recognition. It demonstrates a higher level of expertise, dedication, and commitment to your field, which can be valuable when seeking career opportunities or pursuing leadership roles.',
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
