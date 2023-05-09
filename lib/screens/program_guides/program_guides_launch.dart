import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mentorx_mvp/models/program_guides_models/track_status.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_101/track1_guides_launch.dart';

import '../../components/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramGuidesLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;
  final String trackName;

  const ProgramGuidesLaunchScreen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
    this.trackName,
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
    return StreamBuilder<Object>(
        stream: programsRef
            .doc(widget.programUID)
            .collection('matchedPairs')
            .doc(widget.matchID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          TrackInfo trackInfo = TrackInfo.fromDocument(snapshot.data);

          if (trackInfo.track == 'Track 1') {
            return Track1GuidesLaunchScreen(
              loggedInUser: widget.loggedInUser,
              mentorUID: widget.mentorUID,
              programUID: widget.programUID,
              matchID: widget.matchID,
            );
          }
          return Text('WIP');

          //   Scaffold(
          //   appBar: AppBar(
          //     backgroundColor: kMentorXPPrimary,
          //     elevation: 5,
          //     title: Center(
          //       child: Padding(
          //         padding: const EdgeInsets.only(right: 35.0, bottom: 10),
          //         child: Image.asset(
          //           'assets/images/MentorXP.png',
          //           fit: BoxFit.contain,
          //           height: 35,
          //         ),
          //       ),
          //     ),
          //   ),
          //   body: Container(
          //     child: Column(
          //       children: [
          //         Padding(
          //           padding:
          //               const EdgeInsets.only(left: 5, top: 20.0, right: 5),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Container(
          //                 height: 70,
          //                 width: MediaQuery.of(context).size.width * .95,
          //                 child: Card(
          //                   shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(12.0),
          //                   ),
          //                   color: kMentorXPPrimary,
          //                   child: Center(
          //                     child: Text(
          //                       'Track 1 - Getting Started',
          //                       style: TextStyle(
          //                         color: Colors.white,
          //                         fontFamily: 'Montserrat',
          //                         fontSize: 25,
          //                         fontWeight: FontWeight.bold,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         ProgramGuideMenuTile(
          //           titleText: 'Introductions',
          //           titlePrefix: '1',
          //           iconData: (guideStatus.introductionStatus == 'Current')
          //               ? Icons.play_arrow
          //               : (guideStatus.introductionStatus == null)
          //                   ? Icons.play_arrow
          //                   : Icons.check,
          //           iconColor: (guideStatus.introductionStatus == 'Current')
          //               ? kMentorXPAccentMed
          //               : (guideStatus.introductionStatus == null)
          //                   ? kMentorXPAccentMed
          //                   : kMentorXPSecondary,
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => ProgramGuidesIntrosScreen(
          //                   loggedInUser: widget.loggedInUser,
          //                   matchID: widget.matchID,
          //                   mentorUID: widget.mentorUID,
          //                   programUID: widget.programUID,
          //                 ),
          //               ),
          //             );
          //           },
          //         ),
          //         ProgramGuideMenuTile(
          //           titleText: 'Resume 101',
          //           titlePrefix: '2',
          //           iconData: (guideStatus.resume101Status == 'Current')
          //               ? Icons.play_arrow
          //               : (guideStatus.resume101Status == null)
          //                   ? Icons.lock
          //                   : Icons.check,
          //           iconColor: (guideStatus.resume101Status == 'Current')
          //               ? kMentorXPAccentMed
          //               : (guideStatus.resume101Status == null)
          //                   ? Colors.grey
          //                   : kMentorXPSecondary,
          //           onTap: () {
          //             (guideStatus.resume101Status == null)
          //                 ? ''
          //                 : Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => Resume101Screen(
          //                         loggedInUser: widget.loggedInUser,
          //                         matchID: widget.matchID,
          //                         mentorUID: widget.mentorUID,
          //                         programUID: widget.programUID,
          //                       ),
          //                     ),
          //                   );
          //           },
          //         ),
          //         ProgramGuideMenuTile(
          //           titleText: 'Networking 101',
          //           titlePrefix: '3',
          //           iconData: (guideStatus.networking101Status == 'Current')
          //               ? Icons.play_arrow
          //               : (guideStatus.networking101Status == null)
          //                   ? Icons.lock
          //                   : Icons.check,
          //           iconColor: (guideStatus.networking101Status == 'Current')
          //               ? kMentorXPAccentMed
          //               : (guideStatus.networking101Status == null)
          //                   ? Colors.grey
          //                   : kMentorXPSecondary,
          //           onTap: () {
          //             (guideStatus.networking101Status == null)
          //                 ? ''
          //                 : Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => Networking101Screen(
          //                         loggedInUser: widget.loggedInUser,
          //                         matchID: widget.matchID,
          //                         mentorUID: widget.mentorUID,
          //                         programUID: widget.programUID,
          //                       ),
          //                     ),
          //                   );
          //           },
          //         ),
          //         ProgramGuideMenuTile(
          //           titleText: 'Major / Career Exploration',
          //           titlePrefix: '4',
          //           iconData: (guideStatus.career101Status == 'Current')
          //               ? Icons.play_arrow
          //               : (guideStatus.career101Status == null)
          //                   ? Icons.lock
          //                   : Icons.check,
          //           iconColor: (guideStatus.career101Status == 'Current')
          //               ? kMentorXPAccentMed
          //               : (guideStatus.career101Status == null)
          //                   ? Colors.grey
          //                   : kMentorXPSecondary,
          //           onTap: () {
          //             (guideStatus.career101Status == null)
          //                 ? ''
          //                 : Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => MajorCareer101Screen(
          //                         loggedInUser: widget.loggedInUser,
          //                         matchID: widget.matchID,
          //                         mentorUID: widget.mentorUID,
          //                         programUID: widget.programUID,
          //                       ),
          //                     ),
          //                   );
          //           },
          //         ),
          //         ProgramGuideMenuTile(
          //           titleText: 'Company Exploration',
          //           titlePrefix: '5',
          //           iconData: (guideStatus.company101Status == 'Current')
          //               ? Icons.play_arrow
          //               : (guideStatus.company101Status == null)
          //                   ? Icons.lock
          //                   : Icons.check,
          //           iconColor: (guideStatus.company101Status == 'Current')
          //               ? kMentorXPAccentMed
          //               : (guideStatus.company101Status == null)
          //                   ? Colors.grey
          //                   : kMentorXPSecondary,
          //           onTap: () {
          //             (guideStatus.company101Status == null)
          //                 ? ''
          //                 : Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => Company101Screen(
          //                         loggedInUser: widget.loggedInUser,
          //                         matchID: widget.matchID,
          //                         mentorUID: widget.mentorUID,
          //                         programUID: widget.programUID,
          //                       ),
          //                     ),
          //                   );
          //           },
          //         ),
          //         ProgramGuideMenuTile(
          //           titleText: 'Interview Prep 101',
          //           titlePrefix: '6',
          //           iconData: (guideStatus.interview101Status == 'Current')
          //               ? Icons.play_arrow
          //               : (guideStatus.interview101Status == null)
          //                   ? Icons.lock
          //                   : Icons.check,
          //           iconColor: (guideStatus.interview101Status == 'Current')
          //               ? kMentorXPAccentMed
          //               : (guideStatus.interview101Status == null)
          //                   ? Colors.grey
          //                   : kMentorXPSecondary,
          //           onTap: () {
          //             (guideStatus.interview101Status == null)
          //                 ? ''
          //                 : Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => Interview101Screen(
          //                         loggedInUser: widget.loggedInUser,
          //                         matchID: widget.matchID,
          //                         mentorUID: widget.mentorUID,
          //                         programUID: widget.programUID,
          //                       ),
          //                     ),
          //                   );
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        });
  }
}
