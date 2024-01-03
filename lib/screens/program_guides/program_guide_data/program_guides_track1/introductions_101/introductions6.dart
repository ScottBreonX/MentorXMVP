import 'package:flutter/material.dart';

class Introductions6 extends StatelessWidget {
  const Introductions6({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: RichText(
            text: TextSpan(
              text: '',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Remember, the first meeting is an opportunity to establish a strong foundation for the mentorship relationship. Be open, honest, and supportive, and set clear expectations for the relationship moving forward.',
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
