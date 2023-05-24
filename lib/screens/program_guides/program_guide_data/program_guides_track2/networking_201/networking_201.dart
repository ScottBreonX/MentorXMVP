import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track2/networking_201/networking_201_data_v1.dart';
import '../../../../../components/program_card.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class Networking201Screen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const Networking201Screen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'networking_201_screen';

  @override
  _Networking201ScreenState createState() => _Networking201ScreenState();
}

class _Networking201ScreenState extends State<Networking201Screen> {
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
      'Networking 101': 'Complete',
      'Career 101': 'Current',
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
                      titleText: 'Networking 201',
                      trackText: 'Track 2',
                      fileName: Networking201DataV1(),
                    ),
                    // ProgramGuideCard(
                    //   titleText: 'Networking 201',
                    //   trackText: 'Track 2',
                    //   fileName: Networking101DataV2(),
                    // ),
                    // ProgramGuideCard(
                    //   titleText: 'Networking 201',
                    //   trackText: 'Track 2',
                    //   fileName: Networking101DataV3(),
                    // ),
                    // ProgramGuideCard(
                    //   titleText: 'Networking 201',
                    //   trackText: 'Track 2',
                    //   fileName: Networking101DataV4(),
                    // ),
                    // ProgramGuideCard(
                    //   titleText: 'Networking 201',
                    //   trackText: 'Track 2',
                    //   fileName: Networking101DataV5(),
                    // ),
                    // ProgramGuideCard(
                    //   titleText: 'Networking 201',
                    //   trackText: 'Track 2',
                    //   fileName: Networking101DataV6(),
                    //   selectButtons: true,
                    //   selectButton1: true,
                    //   button1Text: 'Complete Session',
                    //   onPressed1: () async {
                    //     await _markSessionComplete(context, widget.programUID,
                    //         widget.loggedInUser, widget.matchID);
                    //     Navigator.pop(context);
                    //   },
                    // ),
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
