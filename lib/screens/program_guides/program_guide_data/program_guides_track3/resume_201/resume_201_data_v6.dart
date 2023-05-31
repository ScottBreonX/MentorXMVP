import 'package:flutter/material.dart';

class Resume201DataV6 extends StatelessWidget {
  const Resume201DataV6({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Proofread and edit: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Finally, make sure to proofread and edit your resume carefully. Typos and grammatical errors can make you appear unprofessional, so take the time to ensure that your resume is error-free.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
