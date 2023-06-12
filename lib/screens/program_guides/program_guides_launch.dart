import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mentorx_mvp/models/program_guides_models/track_status.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track1/track1_guides_launch.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track2/track2_guides_launch.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track3/track3_guides_launch.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/program_guides_track4/track4_guides_launch.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_tracks/program_guide_tracks.dart';

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
      });
    }
    setState(() {
      isMentor = false;
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
          if (trackInfo.track == 'Track 2') {
            return Track2GuidesLaunchScreen(
              loggedInUser: widget.loggedInUser,
              mentorUID: widget.mentorUID,
              programUID: widget.programUID,
              matchID: widget.matchID,
            );
          }
          if (trackInfo.track == 'Track 3') {
            return Track3GuidesLaunchScreen(
              loggedInUser: widget.loggedInUser,
              mentorUID: widget.mentorUID,
              programUID: widget.programUID,
              matchID: widget.matchID,
            );
          }
          if (trackInfo.track == 'Track 4') {
            return Track4GuidesLaunchScreen(
              loggedInUser: widget.loggedInUser,
              mentorUID: widget.mentorUID,
              programUID: widget.programUID,
              matchID: widget.matchID,
            );
          }
          return ProgramGuideTracks(
            loggedInUser: widget.loggedInUser,
            mentorUID: widget.mentorUID,
            programUID: widget.programUID,
            matchID: widget.matchID,
          );
        });
  }
}
