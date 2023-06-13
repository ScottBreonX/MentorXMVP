import 'package:flutter/material.dart';

class GraduateDegrees401DataV2 extends StatelessWidget {
  const GraduateDegrees401DataV2({
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
              text: '1.  Enhanced Career Opportunities: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'In many fields, a graduate degree can provide a competitive edge and open doors to higher-level positions and increased earning potential. Certain professions, such as academia, research, law, medicine, and engineering, often require advanced degrees for entry or advancement.',
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
