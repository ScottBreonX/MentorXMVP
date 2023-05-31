import 'package:flutter/material.dart';

class CompanyTour201DataV1 extends StatelessWidget {
  const CompanyTour201DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'If you are interested in working for a particular company, you may want to set up a tour to get a better sense of the workplace and company culture. Here are some steps to help you set up a tour:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: RichText(
            text: TextSpan(
              text: 'Research the Company: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Research the company and find out who to contact about setting up a tour. This could be the HR department, a hiring manager, or someone else in the company who can provide more information.',
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
