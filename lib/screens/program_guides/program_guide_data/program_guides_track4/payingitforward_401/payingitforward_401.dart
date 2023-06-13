import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track4/payingitforward_401/payingitforward_401_data_v1.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track4/payingitforward_401/payingitforward_401_data_v2.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track4/payingitforward_401/payingitforward_401_data_v3.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track4/payingitforward_401/payingitforward_401_data_v4.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track4/payingitforward_401/payingitforward_401_data_v5.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track4/payingitforward_401/payingitforward_401_data_v6.dart';
import '../../../../../components/program_card.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class PayingItForward401Screen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const PayingItForward401Screen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'payingitforward_401_screen';

  @override
  _PayingItForward401ScreenState createState() =>
      _PayingItForward401ScreenState();
}

class _PayingItForward401ScreenState extends State<PayingItForward401Screen> {
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
      'Paying It Forward': 'Complete',
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
                      titleText: 'Paying it Forward',
                      trackText: 'Track 4',
                      fileName: PayingItForward01DataV1(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Paying it Forward',
                      trackText: 'Track 4',
                      fileName: PayingItForward01DataV2(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Paying it Forward',
                      trackText: 'Track 4',
                      fileName: PayingItForward01DataV3(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Paying it Forward',
                      trackText: 'Track 4',
                      fileName: PayingItForward01DataV4(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Paying it Forward',
                      trackText: 'Track 4',
                      fileName: PayingItForward01DataV5(),
                    ),
                    ProgramGuideCard(
                      titleText: 'Paying it Forward',
                      trackText: 'Track 4',
                      fileName: PayingItForward01DataV6(),
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