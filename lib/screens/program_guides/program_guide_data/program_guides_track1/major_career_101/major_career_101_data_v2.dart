import 'package:flutter/material.dart';

class MajorCareer101DataV2 extends StatelessWidget {
  const MajorCareer101DataV2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 00.0),
          child: RichText(
            text: TextSpan(
              text:
                  '3. Research careers in the fields that might be a good fit for your interests and skills. ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Look up job descriptions, education requirements, and available programs at your school.',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            'As you research various industries, '
            'be sure to take note of what seems interesting as well '
            'as what you might dislike. Identifying the fields you don’t '
            'like can help narrow down your path.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
