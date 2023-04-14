import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';

import '../../../../../components/program_card.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MajorCareer101Screen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const MajorCareer101Screen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'major_career_101_screen';

  @override
  _MajorCareer101ScreenState createState() => _MajorCareer101ScreenState();
}

class _MajorCareer101ScreenState extends State<MajorCareer101Screen> {
  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXPPrimary,
        elevation: 5,
        title: Image.asset(
          'assets/images/MentorXP.png',
          height: 100,
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
                      titleText: 'Career Exploration 101',
                      trackText: 'Track 1',
                      // fileName: MajorCareer101DataV1(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Career Exploration 101',
                      trackText: 'Track 1',
                      // fileName: MajorCareer101DataV2(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Career Exploration 101',
                      trackText: 'Track 1',
                      // fileName: MajorCareer101DataV3(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Career Exploration 101',
                      trackText: 'Track 1',
                      // fileName: MajorCareer101DataV4(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Career Exploration 101',
                      trackText: 'Track 1',
                      // fileName: MajorCareer101DataV5(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Career Exploration 101',
                      trackText: 'Track 1',
                      // fileName: MajorCareer101DataV6(),
                      selectButtons: true,
                      selectButton1: true,
                      button1Text: 'Complete Session',
                      onPressed1: () {
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
