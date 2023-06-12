import 'package:flutter/material.dart';

class JobShadow301DataV1 extends StatelessWidget {
  const JobShadow301DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Job shadowing is a great way to learn about a career you\'re interested in. It\'s an opportunity to spend time with someone who works in that field and see what their day-to-day work is like. You can ask questions, learn about the challenges and rewards of the job, and get a sense of whether it\'s a good fit for you.',
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
