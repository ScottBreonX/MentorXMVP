import 'package:flutter/material.dart';

class Coaching301DataV2 extends StatelessWidget {
  const Coaching301DataV2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Coaching is unlocking a person’s potential to maximize their own performance and helping them learn rather than teaching them.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Text(
            'Skills & Behaviors of a good coach: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              Text(
                '\u2022 Cares personally about the individual',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                '\u2022 Provides specific, timely, constructive feedback',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                '\u2022 Asks probing questions to enable self realization & explore options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                '\u2022 Focuses on long-term goals and aspirations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
