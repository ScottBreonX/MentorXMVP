import 'package:flutter/material.dart';

class DiversityInclusion401DataV1 extends StatelessWidget {
  const DiversityInclusion401DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Diversity, equity, and inclusion (DEI) are interconnected concepts that address different aspects of creating a more inclusive and equitable society or organization:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RichText(
            text: TextSpan(
              text: 'Diversity: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      'Diversity refers to the presence and representation of a wide range of human differences within a group, community, or organization.',
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
