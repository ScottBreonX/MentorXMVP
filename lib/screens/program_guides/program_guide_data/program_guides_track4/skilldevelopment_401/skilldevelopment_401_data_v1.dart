import 'package:flutter/material.dart';

class SkillDevelopment401DataV1 extends StatelessWidget {
  const SkillDevelopment401DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Transferable skills are necessary to build the foundation of your resume, and will always be relevant in your career. However, there are a variety of specialized skills that can contribute to landing your dream job.',
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
              text: 'Adaptability and Flexibility: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'In today\'s rapidly changing world, being adaptable and open to new ideas is important.',
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
