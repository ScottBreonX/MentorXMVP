import 'package:flutter/material.dart';

class EmotionalIntelligence401DataV3 extends StatelessWidget {
  const EmotionalIntelligence401DataV3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RichText(
            text: TextSpan(
              text: '2. Better Relationships: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'People with high emotional intelligence are better at forming and maintaining positive relationships with others. By recognizing and understanding their own emotions, they can better manage their reactions to others, which helps to build trust and rapport.',
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
