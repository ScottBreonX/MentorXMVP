import 'package:flutter/material.dart';

class Resume201DataV3 extends StatelessWidget {
  const Resume201DataV3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'List your work experience: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'In this section, list your work history in reverse chronological order, starting with your most recent job. Include the name of the company, your job title, and the dates you worked there. For each job, list your responsibilities and accomplishments in bullet points.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
