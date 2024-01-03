import 'package:flutter/material.dart';

class MajorCareer101DataV3 extends StatelessWidget {
  const MajorCareer101DataV3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            'Discuss the potential career opportunities and '
            'how you have each gotten to this point. '
            'Based on the prior steps, talk about potential '
            'degrees that might be worth pursuing.',
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
            'By identifying your interests and exploring different '
            'options, you can make an informed decision and '
            'increase the chances of job satisfaction.',
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
