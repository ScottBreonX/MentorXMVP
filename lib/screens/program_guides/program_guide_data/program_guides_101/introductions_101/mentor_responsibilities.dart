import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/introductions_101/mentorResponsibilities1.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/introductions_101/mentorResponsibilities2.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/introductions_101/mentorResponsibilities3.dart';
import '../../../../../components/program_card.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentorResponsibilitiesScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const MentorResponsibilitiesScreen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'mentor_responsibilities_screen';

  @override
  _MentorResponsibilitiesScreenState createState() =>
      _MentorResponsibilitiesScreenState();
}

class _MentorResponsibilitiesScreenState
    extends State<MentorResponsibilitiesScreen> {
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
                      titleText: 'Role & Responsibility of a Mentor',
                      cardColor: Colors.grey.shade700,
                      fileName: MentorResponsibilities1(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Role & Responsibility of a Mentor',
                      cardColor: Colors.grey.shade700,
                      fileName: MentorResponsibilities2(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Role & Responsibility of a Mentor',
                      cardColor: Colors.grey.shade700,
                      fileName: MentorResponsibilities3(),
                      selectButtons: true,
                      selectButton2: true,
                      button2Text: 'Return',
                      onPressed2: () {
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
