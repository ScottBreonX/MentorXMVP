import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/resume_101/resume_dont_data_v1.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/resume_101/resume_dont_data_v2.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/resume_101/resume_dont_data_v3.dart';

import '../../../../../components/program_card.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ResumeDontScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const ResumeDontScreen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'resume_do_screen';

  @override
  _ResumeDontScreenState createState() => _ResumeDontScreenState();
}

class _ResumeDontScreenState extends State<ResumeDontScreen> {
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
                      titleText: 'Resume Don\'ts',
                      fileName: ResumeDontDataV1(),
                      cardColor: Colors.grey.shade700,
                    ),
                    ProgramGuideCard(
                      titleText: 'Resume Don\'ts',
                      fileName: ResumeDontDataV2(),
                      cardColor: Colors.grey.shade700,
                    ),
                    ProgramGuideCard(
                      titleText: 'Resume Don\'ts',
                      fileName: ResumeDontDataV3(),
                      cardColor: Colors.grey.shade700,
                      selectButtons: true,
                      selectButton1: true,
                      button1Text: 'Return',
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
                for (int i = 0; i < 3; i++)
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
