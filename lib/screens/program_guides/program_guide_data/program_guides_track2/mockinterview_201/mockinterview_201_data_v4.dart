import 'package:flutter/material.dart';

class MockInterview201DataV4 extends StatelessWidget {
  const MockInterview201DataV4({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Practice More: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Based on the feedback you receive, continue to practice and refine your answers. Conduct additional mock interviews until you feel confident and prepared for the actual interview.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
