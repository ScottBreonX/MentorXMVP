import 'package:flutter/material.dart';

class Resume101DataV5 extends StatelessWidget {
  const Resume101DataV5({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 00.0),
          child: Text(
            'Don\’t worry if you feel like your resume is still '
            'a work in progress. Our experiences and goals '
            'evolve over time, so it\’s important to maintain a current resume.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            'No matter your field of study, there will always '
            'be a need or transferable skills.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            'A transferable skill is a skill that '
            'can be applied in different situations or contexts, '
            'easily transferred from one job to another.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black54,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
