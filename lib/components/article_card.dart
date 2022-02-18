import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    Key key,
    this.bodyText,
    this.articleTitle,
    this.articleSubTitle,
    this.articleIcon,
  }) : super(key: key);

  final String bodyText;
  final String articleTitle;
  final String articleSubTitle;
  final IconData articleIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 250,
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
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    articleIcon ?? Icons.assignment_rounded,
                    size: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        articleSubTitle ?? 'Upcoming',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        articleTitle ?? 'TBD',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        bodyText ?? 'Upcoming program TBD',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
