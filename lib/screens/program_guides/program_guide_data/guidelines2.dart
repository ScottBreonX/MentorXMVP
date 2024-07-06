import 'package:flutter/material.dart';

class Guidelines2 extends StatelessWidget {
  const Guidelines2({
    this.bodyTextColor,
    Key key,
  }) : super(key: key);

  final Color bodyTextColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              text: 'Accountability: ',
              style: TextStyle(
                color: bodyTextColor ?? Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'The mentee should take responsibility for their own progress and be accountable for meeting the goals set forth in the program. The mentor can provide guidance and support, but ultimately the mentee is responsible for their own growth.',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: RichText(
              text: TextSpan(
                text: 'Feedback: ',
                style: TextStyle(
                  color: bodyTextColor ?? Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text:
                        'Both the mentor and mentee should be open to giving and receiving feedback. Constructive feedback should be given in a respectful manner and received with an open mind.',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: RichText(
              text: TextSpan(
                text: 'Termination: ',
                style: TextStyle(
                  color: bodyTextColor ?? Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text:
                    'Either the mentor or mentee may terminate the mentorship program at any time if it is no longer serving its purpose or if the relationship has become untenable. A notice period may be required to ensure a smooth transition.',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: RichText(
              text: TextSpan(
                text: '',
                style: TextStyle(
                  color: bodyTextColor ?? Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text:
                    'These rules are not exhaustive and may be adapted to suit the needs of the mentorship program. The most important thing is that both parties are committed to the program and work towards achieving the agreed-upon goals.',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
