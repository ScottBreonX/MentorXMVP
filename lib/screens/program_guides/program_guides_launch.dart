import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mentorx_mvp/components/program_guides_menu.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/company_101/company_101.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/interview_101/interview_101.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/major_career_101/major_career_101.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/networking_101/networking_101.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/resume_101/resume_101.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/introductions_101/program_guides_intros.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramGuidesLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const ProgramGuidesLaunchScreen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'program_guides_launch_screen';

  @override
  _ProgramGuidesLaunchScreenState createState() =>
      _ProgramGuidesLaunchScreenState();
}

class _ProgramGuidesLaunchScreenState extends State<ProgramGuidesLaunchScreen> {
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
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 20.0, right: 5),
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
                          'Track 1 - Getting Started',
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProgramGuidesIntrosScreen(
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
              titleText: 'Resume 101',
              titlePrefix: '2',
              iconData: Icons.lock,
              iconColor: Colors.black45,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Resume101Screen(
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
              titleText: 'Networking 101',
              titlePrefix: '3',
              iconData: Icons.lock,
              iconColor: Colors.black45,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Networking101Screen(
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
              titleText: 'Major / Career Exploration',
              titlePrefix: '4',
              iconData: Icons.lock,
              iconColor: Colors.black45,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MajorCareer101Screen(
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
              iconData: Icons.lock,
              iconColor: Colors.black45,
              onTap: () {
                Navigator.push(
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
              iconData: Icons.lock,
              iconColor: Colors.black45,
              onTap: () {
                Navigator.push(
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
          ],
        ),
      ),
    );
  }
}
