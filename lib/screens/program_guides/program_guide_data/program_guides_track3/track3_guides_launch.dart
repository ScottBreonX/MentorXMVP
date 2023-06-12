import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mentorx_mvp/components/program_guides_menu.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/program_guides_models/program_guides.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track1/introductions_101/program_guides_intros.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track2/companytour_201/companytour_201.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track2/resume_201/resume_201.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track3/interviewprep_301/interviewprep_301.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track3/mentor_301/mentor_301.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track3/networking_301/networking_301.dart';

import '../../../../components/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class Track3GuidesLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const Track3GuidesLaunchScreen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'track3_guides_launch_screen';

  @override
  _Track3GuidesLaunchScreenState createState() =>
      _Track3GuidesLaunchScreenState();
}

class _Track3GuidesLaunchScreenState extends State<Track3GuidesLaunchScreen> {
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
                                'Track 3 - Refinement',
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
                            nextGuide: 'Interview 301',
                          ),
                        ),
                      );
                    },
                  ),
                  ProgramGuideMenuTile(
                    titleText: 'Interview 301',
                    titlePrefix: '2',
                    iconData: (guideStatus.interview301Status == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.interview301Status == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.interview301Status == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.interview301Status == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.interview301Status == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InterviewPrep301Screen(
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
                    titleText: 'Networking 301',
                    titlePrefix: '3',
                    iconData: (guideStatus.networking301Status == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.networking301Status == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.networking301Status == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.networking301Status == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.networking301Status == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Networking301Screen(
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
                    titleText: 'Becoming a Mentor',
                    titlePrefix: '4',
                    iconData: (guideStatus.mentor301Status == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.mentor301Status == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.mentor301Status == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.mentor301Status == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.mentor301Status == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Mentor301Screen(
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
                    titleText: 'Coaching',
                    titlePrefix: '5',
                    iconData: (guideStatus.coaching301Status == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.coaching301Status == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.coaching301Status == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.coaching301Status == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.coaching301Status == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Resume201Screen(
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
                    titleText: 'Job Shadow',
                    titlePrefix: '6',
                    iconData: (guideStatus.jobShadow301Status == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.jobShadow301Status == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.jobShadow301Status == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.jobShadow301Status == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.jobShadow301Status == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompanyTour201Screen(
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
