import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/mentor_responsibilities.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/introductions1.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/introductions2.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/introductions3.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/introductions4.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/introductions5.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/introductions6.dart';

import '../../components/program_card.dart';
import 'mentee_responsibilities.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramGuidesIntrosScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const ProgramGuidesIntrosScreen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'program_guides_intros_screen';

  @override
  _ProgramGuidesIntrosScreenState createState() =>
      _ProgramGuidesIntrosScreenState();
}

class _ProgramGuidesIntrosScreenState extends State<ProgramGuidesIntrosScreen> {
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
                      titleText: 'Introductions',
                      trackText: 'Track 1',
                      fileName: Introductions1(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Introductions',
                      trackText: 'Track 1',
                      fileName: Introductions2(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Introductions',
                      trackText: 'Track 1',
                      fileName: Introductions3(),
                      selectButtons: true,
                      button1Text: 'Mentor',
                      onPressed1: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MentorResponsibilitiesScreen(
                              loggedInUser: widget.loggedInUser,
                              matchID: widget.matchID,
                              mentorUID: widget.mentorUID,
                              programUID: widget.programUID,
                            ),
                          ),
                        );
                      },
                      button2Text: 'Mentee',
                      onPressed2: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenteeResponsibilitiesScreen(
                              loggedInUser: widget.loggedInUser,
                              matchID: widget.matchID,
                              mentorUID: widget.mentorUID,
                              programUID: widget.programUID,
                            ),
                          ),
                        );
                      },
                    ),
                    ProgramGuideCard(
                      titleText: 'Introductions',
                      trackText: 'Track 1',
                      fileName: Introductions4(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Introductions',
                      trackText: 'Track 1',
                      fileName: Introductions5(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Introductions',
                      trackText: 'Track 1',
                      fileName: Introductions6(),
                      swipeText: 'Complete Session',
                      swipeTextOnTap: () {
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
