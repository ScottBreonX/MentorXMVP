import 'package:flutter/material.dart';

class InterviewPrep301DataV3 extends StatelessWidget {
  const InterviewPrep301DataV3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'It is important to be prepared for an onsite interview. This means researching the company, practicing your answers to common interview questions, and dressing professionally. It is also important to be polite and respectful to everyone you meet during your interview.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Here are some things you can expect during an onsite interview:',
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
