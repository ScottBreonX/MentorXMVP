import 'package:flutter/material.dart';

class Networking301DataV3 extends StatelessWidget {
  const Networking301DataV3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              text: 'Reach out to your alumni network: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Be a good networker When you\'re networking, be sure to be genuine and interested in the people you\'re meeting. Don\'t just ask for favors. Offer to help them out in any way you can.',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Text(
              'By following these tips, you can build a strong network that will help you get hired in the company you want.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
