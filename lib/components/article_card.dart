import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/mentor_card.dart';
import 'package:mentorx_mvp/constants.dart';

import '../models/user.dart';

class ArticleCard extends StatefulWidget {
  const ArticleCard({
    Key key,
    this.bodyText,
    this.articleTitle,
    this.articleIcon,
    this.onTap,
    this.markComplete,
    this.loggedInUser,
    this.cardRequirement,
    this.programUID,
  }) : super(key: key);

  final String bodyText;
  final String articleTitle;
  final IconData articleIcon;
  final Function onTap;
  final bool markComplete;
  final myUser loggedInUser;
  final String programUID;
  final String cardRequirement;

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

bool isChecked = false;

class _ArticleCardState extends State<ArticleCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 5,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).cardColor,
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
                        widget.articleIcon ?? Icons.assignment_rounded,
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
                              widget.articleTitle ?? 'Upcoming',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium,
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
                            widget.bodyText ?? '',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
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
                        child: Container(
                          height: 25,
                          width: 25,
                          child: CheckBox(
                            loggedInUser: widget.loggedInUser,
                            cardRequirement: widget.cardRequirement,
                            programUID: widget.programUID,
                          ),
                        ),
                      ),
                      Text(
                        'Mark Complete',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CheckBox extends StatefulWidget {
  const CheckBox({
    Key key,
    this.loggedInUser,
    this.cardRequirement,
    this.programUID,
  }) : super(key: key);

  final myUser loggedInUser;
  final String cardRequirement;
  final String programUID;
  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return isChecked ? kMentorXPPrimary : kMentorXPAccentDark;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool value) async {
        setState(() {
          isChecked = value;
        });
        await Future.delayed(Duration(seconds: 1));
        await programsRef
            .doc(widget.programUID)
            .collection('userSubscribed')
            .doc(widget.loggedInUser.id)
            .update({"${widget.cardRequirement}": value});
      },
    );
  }
}
