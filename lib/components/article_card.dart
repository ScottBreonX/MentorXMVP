import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    Key key,
    this.bodyText,
    this.articleTitle,
    this.articleIcon,
    this.onTap,
    this.markComplete,
  }) : super(key: key);

  final String bodyText;
  final String articleTitle;
  final IconData articleIcon;
  final Function onTap;
  final Function markComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(1.0),
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[700],
                blurRadius: 5,
                offset: Offset(5, 5),
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      articleIcon ?? Icons.assignment_rounded,
                      size: 40,
                      color: kMentorXPAccentDark,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            articleTitle ?? 'Upcoming',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 190,
                        height: 40,
                        child: Text(
                          bodyText ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          print('Complete');
                        },
                        child: Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.grey,
                          size: 19,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: markComplete,
                      child: Text(
                        'Mark Complete',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black45,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
