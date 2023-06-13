import 'package:flutter/material.dart';

class SkillDevelopment401DataV5 extends StatelessWidget {
  const SkillDevelopment401DataV5({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Hone your research skills, including conducting literature reviews, utilizing credible sources, and interpreting data.',
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
              text: 'Emotional Intelligence: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Enhance your emotional intelligence by developing self-awareness, empathy, and interpersonal skills. This skillset enables you to understand and manage your own emotions and navigate relationships effectively.',
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
