import 'package:flutter/material.dart';

class Resume201DataV2 extends StatelessWidget {
  const Resume201DataV2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Choose the right format: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'There are three main types of resume formats: chronological, functional, and hybrid. A chronological resume lists your work history in reverse chronological order, while a functional resume focuses on your skills and accomplishments. A hybrid resume combines elements of both. Choose the format that best highlights your strengths and is most appropriate for the job you are applying for.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
