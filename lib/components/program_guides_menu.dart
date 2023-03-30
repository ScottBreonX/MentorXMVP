import 'package:flutter/material.dart';

import '../constants.dart';

class ProgramGuideMenuTile extends StatelessWidget {
  final String titleText;
  final String titlePrefix;
  final IconData iconData;
  final Color iconColor;
  final Function onTap;

  const ProgramGuideMenuTile({
    this.titleText,
    this.titlePrefix,
    this.iconData,
    this.iconColor,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(1.0),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[700],
                        blurRadius: 5,
                        offset: Offset(5, 5),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${titlePrefix ?? '1'}',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: kMentorXPAccentDark,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    '${titleText ?? 'TBD'}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat',
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          iconData ?? Icons.play_arrow,
                          size: 40,
                          color: iconColor ?? kMentorXPAccentMed,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
