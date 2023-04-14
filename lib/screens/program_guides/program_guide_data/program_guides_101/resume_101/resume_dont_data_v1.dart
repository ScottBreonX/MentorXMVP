import 'package:flutter/material.dart';

class ResumeDontDataV1 extends StatelessWidget {
  const ResumeDontDataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Don\’t Include Irrelevant Information: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text: 'Focus on experiences that highlight the skills and '
                    'qualifications that are relevant to the job you are '
                    'applying for.  Additional information can make your resume '
                    'too long and dilute the impact of your qualifications.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: RichText(
            text: TextSpan(
              text: 'Don\’t List References: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text: 'Employers will request references if necessary.',
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
