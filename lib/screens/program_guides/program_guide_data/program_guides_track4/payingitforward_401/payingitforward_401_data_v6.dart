import 'package:flutter/material.dart';

class PayingItForward01DataV6 extends StatelessWidget {
  const PayingItForward01DataV6({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Preserving knowledge: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Teaching helps preserve knowledge and pass it on to future generations. By imparting knowledge to others, you ensure that valuable information and skills are not lost over time, but continue to benefit individuals and society in the long run.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'In summary, teaching others is important because it enables knowledge sharing, reinforces learning, builds relationships, empowers individuals, promotes critical thinking, creates a positive impact, and preserves knowledge for future generations.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
