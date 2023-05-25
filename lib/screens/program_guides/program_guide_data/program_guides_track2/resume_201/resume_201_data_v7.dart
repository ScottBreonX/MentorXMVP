import 'package:flutter/material.dart';

class Resume201DataV7 extends StatelessWidget {
  const Resume201DataV7({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'By following these steps, you can create a strong resume that highlights your skills and experience and helps you stand out from other applicants. Good luck with your job search!',
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
