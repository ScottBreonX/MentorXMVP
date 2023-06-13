import 'package:flutter/material.dart';

class EmotionalIntelligence401DataV1 extends StatelessWidget {
  const EmotionalIntelligence401DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Emotional Intelligence (EI) is the ability to identify, understand, and manage your own emotions and those of others. It involves being aware of your emotions, managing them effectively, and being able to empathize with others.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Text(
            'In today’s world, it is becoming increasingly important to demonstrate high emotional intelligence to excel in both personal and professional settings.',
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
