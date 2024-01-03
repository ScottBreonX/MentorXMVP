import 'package:flutter/material.dart';

class MajorCareer101DataV5 extends StatelessWidget {
  const MajorCareer101DataV5({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            'You can also try out different classes in '
            'the fields of study that you find interesting. '
            'If you decide that this isn’t the major for you, '
            'it could be something to focus on for a minor or '
            'concentration of study.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            'Ultimately, seeking guidance is a great way to '
            'determine your career path. Advisors, career counselors, '
            'mentors, and other students can all weigh in with valuable insight.',
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
