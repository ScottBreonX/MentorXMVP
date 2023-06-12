import 'package:flutter/material.dart';

class Mentor301DataV5 extends StatelessWidget {
  const Mentor301DataV5({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Be willing to share your knowledge and experience: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'One of the best ways to help your mentee is to share your knowledge and experience with them. This can be done through formal mentoring sessions, as well as through informal conversations and interactions.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Mentoring can be a rewarding experience for both the mentor and the mentee. By following these tips, you can be a great mentor and help your mentee reach their full potential.',
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
