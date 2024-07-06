import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_launch_manage.dart';

import '../constants.dart';

class ProgramGuideCard extends StatefulWidget {
  const ProgramGuideCard({
    this.titleText,
    this.trackText,
    Key key,
    this.bodyText,
    this.swipeText,
    this.fileName,
    this.selectButtons,
    this.selectButton1,
    this.selectButton2,
    this.onPressed1,
    this.onPressed2,
    this.button1Text,
    this.button2Text,
    this.cardColor,
    this.swipeTextOnTap,
    this.filePadding,
    this.textColor,
  }) : super(key: key);

  final String titleText;
  final String trackText;
  final String bodyText;
  final String swipeText;
  final Widget fileName;
  final bool selectButtons;
  final bool selectButton1;
  final bool selectButton2;
  final Function onPressed1;
  final Function onPressed2;
  final Color cardColor;
  final Function swipeTextOnTap;
  final EdgeInsets filePadding;
  final Color textColor;

  final String button1Text;
  final String button2Text;

  @override
  State<ProgramGuideCard> createState() => _ProgramGuideCardState();
}

class _ProgramGuideCardState extends State<ProgramGuideCard> {
  @override
  void initState() {
    super.initState();
  }

  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              kMentorXPPrimary.withOpacity(0.1),
              kMentorXPPrimary.withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: RawScrollbar(
            controller: _firstController,
            thumbVisibility: false,
            thickness: 10,
            thumbColor: kMentorXPSecondary.withOpacity(0.8),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: _firstController,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    Text(
                      widget.titleText ?? 'N/A',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kMentorXPPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Text(
                      widget.trackText ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kMentorXPAccentMed,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Padding(
                      padding:
                          widget.filePadding ?? const EdgeInsets.only(top: 5),
                      child: widget.fileName ?? Text(''),
                    ),
                    widget.selectButtons ?? false
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                widget.selectButton1 ?? false
                                    ? ButtonCard(
                                        buttonCardText:
                                            '${widget.button1Text ?? ''}',
                                        onPressed: widget.onPressed1 ?? () {},
                                        cardIconBool: Container(),
                                        cardAlignment: MainAxisAlignment.center,
                                        buttonCardColor: kMentorXPAccentDark,
                                        buttonCardTextColor: Colors.white,
                                        buttonCardTextSize: 15,
                                        buttonCardRadius: 20,
                                        buttonCardHeight: 70,
                                        cardWidthPercent: .50,
                                      )
                                    : Container(),
                                widget.selectButton2 ?? false
                                    ? ButtonCard(
                                        buttonCardText:
                                            '${widget.button2Text ?? ''}',
                                        onPressed: widget.onPressed2 ?? () {},
                                        cardIconBool: Container(),
                                        cardAlignment: MainAxisAlignment.center,
                                        buttonCardColor: kMentorXPSecondary,
                                        buttonCardTextColor: Colors.white,
                                        buttonCardTextSize: 15,
                                        buttonCardRadius: 20,
                                        buttonCardHeight: 70,
                                        cardWidthPercent: .50,
                                      )
                                    : Container()
                              ],
                            ),
                          )
                        : Container(),
                    // Spacer(),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 10.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       GestureDetector(
                    //         onTap: widget.swipeTextOnTap ?? () {},
                    //         child: Text(
                    //           widget.swipeText ?? 'Swipe for next part',
                    //           style: TextStyle(
                    //             color: kMentorXPAccentMed,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold,
                    //             fontStyle: FontStyle.italic,
                    //             fontFamily: 'Montserrat',
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
