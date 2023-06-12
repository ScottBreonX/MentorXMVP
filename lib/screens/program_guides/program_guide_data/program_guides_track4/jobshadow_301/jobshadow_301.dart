import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track3/jobshadow_301/jobshadow_301_data_v1.dart';
import '../../../../../components/program_card.dart';
import 'jobshadow_301_data_v2.dart';
import 'jobshadow_301_data_v3.dart';
import 'jobshadow_301_data_v4.dart';
import 'jobshadow_301_data_v5.dart';
import 'jobshadow_301_data_v6.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class JobShadow301Screen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const JobShadow301Screen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'jobshadow_301_screen';

  @override
  _JobShadow301ScreenState createState() => _JobShadow301ScreenState();
}

class _JobShadow301ScreenState extends State<JobShadow301Screen> {
  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;

  _markSessionComplete(
      context, String programUID, myUser loggedInUser, String matchID) async {
    await programsRef
        .doc(programUID)
        .collection('matchedPairs')
        .doc(matchID)
        .collection('programGuides')
        .doc(loggedInUser.id)
        .update({
      'Job Shadow 301': 'Complete',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXPPrimary,
        elevation: 5,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 35.0, bottom: 10),
            child: Image.asset(
              'assets/images/MentorXP.png',
              fit: BoxFit.contain,
              height: 35,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: Container(
                height: 600,
                width: double.infinity,
                child: CarouselSlider(
                  options: CarouselOptions(
                      height: double.infinity,
                      viewportFraction: 0.88,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.2,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      }),
                  items: [
                    ProgramGuideCard(
                      titleText: 'Job Shadow',
                      trackText: 'Track 3',
                      fileName: JobShadow301DataV1(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Job Shadow',
                      trackText: 'Track 3',
                      fileName: JobShadow301DataV2(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Job Shadow',
                      trackText: 'Track 3',
                      fileName: JobShadow301DataV3(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Job Shadow',
                      trackText: 'Track 3',
                      fileName: JobShadow301DataV4(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Job Shadow',
                      trackText: 'Track 3',
                      fileName: JobShadow301DataV5(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Job Shadow',
                      trackText: 'Track 3',
                      fileName: JobShadow301DataV6(),
                      selectButtons: true,
                      selectButton1: true,
                      button1Text: 'Complete Session',
                      onPressed1: () async {
                        await _markSessionComplete(context, widget.programUID,
                            widget.loggedInUser, widget.matchID);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 6; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: currentIndex == i
                            ? kMentorXPAccentMed
                            : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
