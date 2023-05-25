import 'package:flutter/material.dart';

class MockInterview201DataV5 extends StatelessWidget {
  const MockInterview201DataV5({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'By following these steps, you can effectively perform a mock interview and prepare for an actual job interview. Mock interviews can help you identify areas where you need to improve, build your confidence, and increase your chances of landing the job.',
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
