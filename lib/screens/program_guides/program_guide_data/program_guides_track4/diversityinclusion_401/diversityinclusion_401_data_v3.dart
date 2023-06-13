import 'package:flutter/material.dart';

class DiversityInclusion401DataV3 extends StatelessWidget {
  const DiversityInclusion401DataV3({
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
              text: 'Equity: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Equity focuses on ensuring fairness and justice by providing equal opportunities and access to resources, benefits, and support for all individuals, regardless of their background or circumstances.',
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
