import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mentorx_mvp/components/program_guides_menu.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/program_guides_models/program_guides.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track1/introductions_101/program_guides_intros.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track3/coaching_301/coaching_301.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track3/interviewprep_301/interviewprep_301.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track3/jobshadow_301/jobshadow_301.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track3/mentor_301/mentor_301.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track3/networking_301/networking_301.dart';

import '../../../../components/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class Track4GuidesLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const Track4GuidesLaunchScreen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'track4_guides_launch_screen';

  @override
  _Track4GuidesLaunchScreenState createState() =>
      _Track4GuidesLaunchScreenState();
}

class _Track4GuidesLaunchScreenState extends State<Track4GuidesLaunchScreen> {
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
      });
    }
    setState(() {
      isMentor = false;
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
                                'Track 4 - Close Out',
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
                            nextGuide: 'Emotional Intelligence',
                          ),
                        ),
                      );
                    },
                  ),
                  ProgramGuideMenuTile(
                    titleText: 'Emotional Intelligence',
                    titlePrefix: '2',
                    iconData:
                        (guideStatus.emotionalIntelligenceStatus == 'Current')
                            ? Icons.play_arrow
                            : (guideStatus.emotionalIntelligenceStatus == null)
                                ? Icons.lock
                                : Icons.check,
                    iconColor:
                        (guideStatus.emotionalIntelligenceStatus == 'Current')
                            ? kMentorXPAccentMed
                            : (guideStatus.emotionalIntelligenceStatus == null)
                                ? Colors.grey
                                : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.emotionalIntelligenceStatus == null)
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
                    titleText: 'Diversity & Inclusion',
                    titlePrefix: '3',
                    iconData: (guideStatus.diversityInclusion == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.diversityInclusion == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.diversityInclusion == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.diversityInclusion == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.diversityInclusion == null)
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
                    titleText: 'Skill Development',
                    titlePrefix: '4',
                    iconData: (guideStatus.skillDevelopment == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.skillDevelopment == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.skillDevelopment == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.skillDevelopment == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.skillDevelopment == null)
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
                    titleText: 'Graduate Degrees',
                    titlePrefix: '5',
                    iconData: (guideStatus.graduateDegrees == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.graduateDegrees == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.graduateDegrees == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.graduateDegrees == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.graduateDegrees == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Coaching301Screen(
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
                    titleText: 'Paying it Forward',
                    titlePrefix: '6',
                    iconData: (guideStatus.payingItForward == 'Current')
                        ? Icons.play_arrow
                        : (guideStatus.payingItForward == null)
                            ? Icons.lock
                            : Icons.check,
                    iconColor: (guideStatus.payingItForward == 'Current')
                        ? kMentorXPAccentMed
                        : (guideStatus.payingItForward == null)
                            ? Colors.grey
                            : kMentorXPSecondary,
                    onTap: () {
                      (guideStatus.payingItForward == null)
                          ? ''
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobShadow301Screen(
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
