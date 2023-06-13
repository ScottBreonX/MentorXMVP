import 'package:flutter/material.dart';

class SkillDevelopment401DataV2 extends StatelessWidget {
  const SkillDevelopment401DataV2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Embrace change, be willing to learn and unlearn, and demonstrate resilience in the face of challenges.',
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
              text: 'Technical Skills: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'These skills are specific to a particular job or industry and are typically gained through education, training programs, or hands-on experience. Examples include: programming languages, data analysis, graphic design, & financial modeling.',
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
