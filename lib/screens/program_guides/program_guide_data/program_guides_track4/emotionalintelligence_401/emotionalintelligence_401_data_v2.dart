import 'package:flutter/material.dart';

class EmotionalIntelligence401DataV2 extends StatelessWidget {
  const EmotionalIntelligence401DataV2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'EI is a skill that can always be improved. Frequent assessment of your emotional intelligence  can be a valuable tool for growth and personal development. Benefits of evolving your EI include:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RichText(
            text: TextSpan(
              text: '1. Improved Communication: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'EI allows individuals to understand the deeper meaning behind words, leading to more effective communication. Recognizing nonverbal cues and actively listening can  help one see the bigger picture.',
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
