import 'package:flutter/material.dart';

class PayingItForward01DataV4 extends StatelessWidget {
  const PayingItForward01DataV4({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Empowering others: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            children: const <TextSpan>[
              TextSpan(
                text:
                    'Teaching empowers individuals by providing them with the tools and knowledge they need to succeed. By sharing your expertise, you can inspire and motivate others to pursue their goals, acquire new skills, and broaden their horizons.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RichText(
            text: TextSpan(
              text: 'Promoting critical thinking: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Teaching encourages critical thinking and problem-solving skills. When you teach, you often face questions and challenges that require you to think deeply, analyze information, and find creative solutions.',
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
