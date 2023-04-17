import 'package:flutter/material.dart';

class Company101DataV1 extends StatelessWidget {
  const Company101DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            'Dedicating time to company exploration is essential '
            'to make informed choices. The purpose It can help avoid '
            'pitfalls and ensure that your goals are strategically aligned with '
            'those of your employer.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            'Based on your last session, use your interested '
            'careers to look up the top employers in this industry. '
            'Make a list of five companies that you want to learn more about.',
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
