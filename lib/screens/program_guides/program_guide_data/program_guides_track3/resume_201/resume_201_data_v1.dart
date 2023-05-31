import 'package:flutter/material.dart';

class Resume201DataV1 extends StatelessWidget {
  const Resume201DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Determine the purpose of your resume: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Before you start writing your resume, it\'s important to identify its purpose. Are you applying for a specific job or are you simply creating a general resume to have on hand? Understanding the purpose of your resume will help you tailor it to your specific goals.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
