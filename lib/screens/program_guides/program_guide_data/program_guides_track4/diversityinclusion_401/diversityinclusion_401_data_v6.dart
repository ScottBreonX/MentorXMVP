import 'package:flutter/material.dart';

class DiversityInclusion401DataV6 extends StatelessWidget {
  const DiversityInclusion401DataV6({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Inclusion requires removing barriers, addressing biases, and promoting a culture of respect and collaboration.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'The interconnected nature of DEI recognizes that diversity alone is not enough. Equity and inclusion are crucial for leveraging the benefits of diversity and creating a more just and inclusive society or organization. By striving for diversity, equity, and inclusion, we aim to create environments where all individuals have equal opportunities, feel respected and valued, and can fully contribute their talents and perspectives.',
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
