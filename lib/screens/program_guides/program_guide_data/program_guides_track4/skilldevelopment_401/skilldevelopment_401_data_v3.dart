import 'package:flutter/material.dart';

class SkillDevelopment401DataV3 extends StatelessWidget {
  const SkillDevelopment401DataV3({
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
              text: 'Leadership Skills: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Develop your leadership skills by taking initiative, motivating others, and being responsible. Leadership is not limited to formal positions but can be demonstrated through influencing others and taking ownership of projects.',
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
