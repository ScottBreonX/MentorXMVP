import 'package:flutter/material.dart';

class GraduateDegrees401DataV4 extends StatelessWidget {
  const GraduateDegrees401DataV4({
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
              text: '3. Access to Research and Resources: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Graduate programs often provide access to extensive research facilities, specialized libraries, academic journals, and other resources that can enrich your learning experience and support your research endeavors.',
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
