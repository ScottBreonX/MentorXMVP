import 'package:flutter/material.dart';

class Mentor301DataV3 extends StatelessWidget {
  const Mentor301DataV3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Be patient and understanding: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Everyone learns at their own pace. Be patient with your mentee as they learn and grow. Be understanding of their mistakes and setbacks.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: RichText(
            text: TextSpan(
              text: 'Be honest and open: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Build trust with your mentee by being honest and open with them. Be truthful about your own experiences and mistakes. This will help your mentee feel comfortable sharing their own thoughts and feelings with you.',
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
