import 'package:flutter/material.dart';

class ResumeDontDataV3 extends StatelessWidget {
  const ResumeDontDataV3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Don\’t overdo formatting: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text: 'Avoid using fancy fonts, colors, and graphics. '
                    'Spacing and formatting should be consistent throughout. '
                    'Keep your resume easy to read and do not exceed one page.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
