import 'package:flutter/material.dart';

class DiversityInclusion401DataV2 extends StatelessWidget {
  const DiversityInclusion401DataV2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'These differences can include but are not limited to race, ethnicity, gender, age, sexual orientation, religion, socioeconomic status, disabilities, and cultural backgrounds.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Embracing diversity recognizes and values the unique perspectives, experiences, and identities that individuals bring to the table.',
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
