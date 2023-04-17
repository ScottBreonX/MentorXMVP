import 'package:flutter/material.dart';

class Interview101DataV4 extends StatelessWidget {
  const Interview101DataV4({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            'To increase your chances at landing your dream job, it is best to familiarize yourself and prepare for each.',
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
