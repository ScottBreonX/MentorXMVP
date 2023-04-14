import 'package:flutter/material.dart';

class Resume101DataV2 extends StatelessWidget {
  const Resume101DataV2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'First Impressions: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text: 'Resumes often serve as the foundation for the '
                    'employer and candidate relationship, providing an '
                    'opportunity to make a strong first impression.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: RichText(
            text: TextSpan(
              text: 'Showcasing Qualifications: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Include certifications, accomplishments, and skills that are relevant to the position and highlight your ability to perform the job.',
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
