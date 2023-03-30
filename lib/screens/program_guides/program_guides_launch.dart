import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mentorx_mvp/components/program_guides_menu.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guides_intros.dart';

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
          child: Image.asset(
            'assets/images/MentorXP.png',
            height: 100,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 20.0),
              child: Row(
                children: [
                  Container(
                    height: 70,
                    width: 200,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: kMentorXPPrimary,
                      child: Center(
                        child: Text(
                          'Track 1 / 3',
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
            ),
            ProgramGuideMenuTile(
              titleText: 'Networking 101',
              titlePrefix: '3',
              iconData: Icons.lock,
              iconColor: Colors.black45,
            ),
            ProgramGuideMenuTile(
              titleText: 'Major / Career Exploration',
              titlePrefix: '4',
              iconData: Icons.lock,
              iconColor: Colors.black45,
            ),
            ProgramGuideMenuTile(
              titleText: 'Company Exploration',
              titlePrefix: '5',
              iconData: Icons.lock,
              iconColor: Colors.black45,
            ),
            ProgramGuideMenuTile(
              titleText: 'Interview Prep 101',
              titlePrefix: '6',
              iconData: Icons.lock,
              iconColor: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
