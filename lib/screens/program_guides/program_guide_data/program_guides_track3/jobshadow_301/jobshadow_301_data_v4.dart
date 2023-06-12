import 'package:flutter/material.dart';

class JobShadow301DataV4 extends StatelessWidget {
  const JobShadow301DataV4({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Text(
            'Here are some tips on how to conduct a job shadow:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: RichText(
              text: TextSpan(
                text: 'Do your research: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text:
                        'Before you reach out to someone to shadow, take some time to learn about the career you\'re interested in. This will help you ask more informed questions and make the most of your time.',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: RichText(
              text: TextSpan(
                text: 'Reach out to someone in your field: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text:
                        'There are a few different ways to find someone to shadow. You can ask your friends, family, or teachers for',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
