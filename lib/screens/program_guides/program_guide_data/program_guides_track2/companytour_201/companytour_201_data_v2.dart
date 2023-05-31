import 'package:flutter/material.dart';

class CompanyTour201DataV2 extends StatelessWidget {
  const CompanyTour201DataV2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Make Contact: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Reach out to the appropriate person via email or phone and express your interest in the company and desire to tour the workplace. Be clear about your intentions and provide some context for why you want to tour the workplace.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RichText(
            text: TextSpan(
              text: 'Set a Date and Time: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Work with the company to set a date and time for the tour. Be flexible and accommodating with their schedule, and make sure you are clear about the details of the tour, including where to meet and what to expect.',
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
