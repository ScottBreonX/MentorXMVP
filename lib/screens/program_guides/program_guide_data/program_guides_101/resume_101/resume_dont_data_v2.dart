import 'package:flutter/material.dart';

class ResumeDontDataV2 extends StatelessWidget {
  const ResumeDontDataV2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Don\’t Exaggerate Qualifications: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text: 'Be honest about your skills and achievements.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: RichText(
            text: TextSpan(
              text: 'Don’t Include Personal Information: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text: 'Personal details such as your hobbies, age, '
                      'relationship status, and religion are not '
                      'necessary. Only include information that is related '
                      'to the job performance.',
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
