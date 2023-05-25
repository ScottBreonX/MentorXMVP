import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mentorx_mvp/components/program_guides_menu.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/program_guides_models/program_guides.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/company_101/company_101.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/interview_101/interview_101.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/introductions_101/program_guides_intros.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track2/interviewprep_201/interviewprep_201.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track2/mockinterview_201/mockinterview_201.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track2/networking_201/networking_201.dart';

import '../../../../components/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class Track2GuidesLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const Track2GuidesLaunchScreen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'track2_guides_launch_screen';

  @override
  _Track2GuidesLaunchScreenState createState() =>
      _Track2GuidesLaunchScreenState();
}

class _Track2GuidesLaunchScreenState extends State<Track2GuidesLaunchScreen> {
  @override
  void initState() {
    checkIsMentor();
    super.initState();
  }

  bool isMentor = false;

  checkIsMentor() async {
    DocumentSnapshot doc = await programsRef
        .doc(widget.programUID)
        .collection('mentors')
        .doc(widget.loggedInUser.id)
        .get();
    if (doc.exists) {
      setState(() {
        isMentor = true;
        print("isMentor");
      });
    }
    setState(() {
      isMentor = false;
      print("isNotMentor");
    });
  }

  _trackWithdraw() async {
    await programsRef
        .doc(widget.programUID)
        .collection('matchedPairs')
        .doc(widget.matchID)
        .update({'Track': '', 'Track Selected': false});
    await programsRef
        .doc(widget.programUID)
        .collection('matchedPairs')
        .doc(widget.matchID)
        .collection('programGuides')
        .doc(widget.loggedInUser.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: programsRef
            .doc(widget.programUID)
            .collection('matchedPairs')
            .doc(widget.matchID)
            .collection('programGuides')
            .doc(widget.loggedInUser.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          ProgramGuideStatus guideStatus =
              ProgramGuideStatus.fromDocument(snapshot.data);

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
            body: Container(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5, top: 20.0, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width * .95,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            color: kMentorXPPrimary,
                            child: Center(
                              child: Text(
                                'Track 2 - Making Progress',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ProgramGuideMenuTile(
                    titleText: 'Introductions',
                    titlePrefix: '1',
                    iconData: (guideStatus.introductionStatus == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.introductionStatus == null)
                            ? Icons.play_arrow
                            : Icons.check,
                    iconColor: (guideStatus.introductionStatus == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.introductionStatus == null)
                            ? kMentorXPAccentMed
                            : kMentorXPSecondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProgramGuidesIntrosScreen(
                            loggedInUser: widget.loggedInUser,
                            matchID: widget.matchID,
                            mentorUID: widget.mentorUID,
                            programUID: widget.programUID,
                            nextGuide: 'Networking 201',
                          ),
                        ),
                      );
                    },
                  ),
                  ProgramGuideMenuTile(
                    titleText: 'Networking 201',
                    titlePrefix: '2',
                    iconData: (guideStatus.networking201Status == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.networking201Status == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.networking201Status == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.networking201Status == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.networking201Status == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Networking201Screen(
                                  loggedInUser: widget.loggedInUser,
                                  matchID: widget.matchID,
                                  mentorUID: widget.mentorUID,
                                  programUID: widget.programUID,
                                ),
                              ),
                            );
                    },
                  ),
                  ProgramGuideMenuTile(
                    titleText: 'Interview Prep 201',
                    titlePrefix: '3',
                    iconData: (guideStatus.interviewPrep201status == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.interviewPrep201status == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.interviewPrep201status == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.interviewPrep201status == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.interviewPrep201status == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InterviewPrep201Screen(
                                  loggedInUser: widget.loggedInUser,
                                  matchID: widget.matchID,
                                  mentorUID: widget.mentorUID,
                                  programUID: widget.programUID,
                                ),
                              ),
                            );
                    },
                  ),
                  ProgramGuideMenuTile(
                    titleText: 'Mock Interview',
                    titlePrefix: '4',
                    iconData: (guideStatus.mockInterview201status == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.mockInterview201status == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.mockInterview201status == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.mockInterview201status == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.mockInterview201status == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MockInterview201Screen(
                                  loggedInUser: widget.loggedInUser,
                                  matchID: widget.matchID,
                                  mentorUID: widget.mentorUID,
                                  programUID: widget.programUID,
                                ),
                              ),
                            );
                    },
                  ),
                  ProgramGuideMenuTile(
                    titleText: 'Company Exploration',
                    titlePrefix: '5',
                    iconData: (guideStatus.company101Status == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.company101Status == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.company101Status == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.company101Status == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.company101Status == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Company101Screen(
                                  loggedInUser: widget.loggedInUser,
                                  matchID: widget.matchID,
                                  mentorUID: widget.mentorUID,
                                  programUID: widget.programUID,
                                ),
                              ),
                            );
                    },
                  ),
                  ProgramGuideMenuTile(
                    titleText: 'Interview Prep 101',
                    titlePrefix: '6',
                    iconData: (guideStatus.interview101Status == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.interview101Status == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.interview101Status == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.interview101Status == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.interview101Status == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Interview101Screen(
                                  loggedInUser: widget.loggedInUser,
                                  matchID: widget.matchID,
                                  mentorUID: widget.mentorUID,
                                  programUID: widget.programUID,
                                ),
                              ),
                            );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _trackWithdraw();
                          },
                          child: Text(
                            'Withdraw from Track',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
