import 'package:flutter/material.dart';

class CompanyTour201DataV3 extends StatelessWidget {
  const CompanyTour201DataV3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Prepare for the Tour: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Before the tour, research the company and its products or services so you can ask informed questions. Dress professionally and bring a notepad and pen to take notes.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: RichText(
            text: TextSpan(
              text: 'Follow Up: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'After the tour, be sure to follow up with a thank-you note or email to the person who arranged the tour. This can help you leave a positive impression and show your continued interest in the company.',
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
