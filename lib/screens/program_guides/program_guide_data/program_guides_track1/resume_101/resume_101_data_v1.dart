import 'package:flutter/material.dart';

class Resume101DataV1 extends StatelessWidget {
  const Resume101DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'A resume is a document that showcases your skills, '
          'qualifications, education,  and experiences.',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            'The purpose is to provide a quick snapshot of '
            'why you are a good fit for the job in a clear and concise manner. '
            'Swipe to see the benefits of having an effective resume.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
