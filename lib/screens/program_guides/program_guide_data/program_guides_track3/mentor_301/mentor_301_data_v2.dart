import 'package:flutter/material.dart';

class Mentor301DataV2 extends StatelessWidget {
  const Mentor301DataV2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Mentors can play a vital role in the mentee\'s life, helping them to reach their full potential. If you are considering becoming a mentor, there are a few things you should keep in mind:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RichText(
            text: TextSpan(
              text:
                  'Be prepared to invest time and energy into the relationship: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Mentoring is a two-way street. It takes time and energy to build a strong relationship with your mentee. Be prepared to meet regularly, offer guidance and support, and be available to answer questions.',
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
