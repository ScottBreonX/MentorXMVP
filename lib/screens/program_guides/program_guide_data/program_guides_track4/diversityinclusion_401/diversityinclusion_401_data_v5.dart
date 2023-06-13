import 'package:flutter/material.dart';

class DiversityInclusion401DataV5 extends StatelessWidget {
  const DiversityInclusion401DataV5({
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
              text: 'Inclusion: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Inclusion refers to creating an environment where everyone feels welcomed, respected, and valued, and where their voices and contributions are heard and considered. Inclusion goes beyond just having diverse individuals present; it involves actively fostering a sense of belonging and ensuring that diverse perspectives are included in decision-making processes and organizational or societal structures.',
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
