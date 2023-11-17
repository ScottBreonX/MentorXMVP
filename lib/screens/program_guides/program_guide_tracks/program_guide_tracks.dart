import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_tracks/track1_data.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_tracks/track2_data.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_tracks/track3_data.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_tracks/track4_data.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guides_launch.dart';
import '../../../../../components/program_card.dart';
import '../../../components/progress.dart';
import '../../../components/rounded_button.dart';
import '../../../models/program_guides_models/track_status.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramGuideTracks extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const ProgramGuideTracks({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'program_guide_tracks';

  @override
  _ProgramGuideTracksState createState() => _ProgramGuideTracksState();
}

_selectTrack(
  context,
  String trackName,
  String programID,
  String matchID,
  String nextTrack,
  String loggedInUserID,
) async {
  await programsRef
      .doc(programID)
      .collection('matchedPairs')
      .doc(matchID)
      .update({
    'Track': trackName,
    'Track Selected': true,
  });
  await programsRef
      .doc(programID)
      .collection('matchedPairs')
      .doc(matchID)
      .collection('programGuides')
      .doc(loggedInUserID)
      .update({
    'Introductions': 'Complete',
    nextTrack: 'Current',
  });
}

welcomeMessage(parentContext) {
  return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Select your track',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kMentorXPAccentDark,
              fontFamily: 'Montserrat',
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                height: 4,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 20.0, right: 20.0, bottom: 10),
              child: Column(
                children: [
                  Text(
                    'As a first step, select the track that best suits your goals to accomplish this mentoring cycle.',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'The track you select will populate guides for you and your mentor to accompany your discussions during the program.',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: 20),
                  RoundedButton(
                    title: 'View Tracks',
                    textAlignment: MainAxisAlignment.center,
                    buttonColor: kMentorXPSecondary,
                    fontColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      });
}

class _ProgramGuideTracksState extends State<ProgramGuideTracks> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => welcomeMessage(context));
  }

  int currentIndex = 0;

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
            return circularProgress(Theme.of(context).primaryColor);
          }
          TrackInfo trackStatus = TrackInfo.fromDocument(snapshot.data);

          if (trackStatus.trackSelected == true) {
            return ProgramGuidesLaunchScreen(
              loggedInUser: widget.loggedInUser,
              mentorUID: widget.mentorUID,
              programUID: widget.programUID,
              matchID: widget.matchID,
              trackName: trackStatus.track,
            );
          }
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
                            titleText: 'Track 1',
                            filePadding: const EdgeInsets.only(top: 0),
                            fileName: Track1Data(
                              fontSize: 17,
                            ),
                            selectButtons: true,
                            selectButton1: true,
                            button1Text: 'Select Track',
                            onPressed1: () {
                              _selectTrack(
                                context,
                                'Track 1',
                                widget.programUID,
                                widget.matchID,
                                'Resume 101',
                                widget.loggedInUser.id,
                              );
                            },
                          ),
                          ProgramGuideCard(
                            titleText: 'Track 2',
                            filePadding: const EdgeInsets.only(top: 0),
                            fileName: Track2Data(
                              fontSize: 17,
                            ),
                            selectButtons: true,
                            selectButton1: true,
                            button1Text: 'Select Track',
                            onPressed1: () {
                              _selectTrack(
                                context,
                                'Track 2',
                                widget.programUID,
                                widget.matchID,
                                'Networking 201',
                                widget.loggedInUser.id,
                              );
                            },
                          ),
                          ProgramGuideCard(
                            titleText: 'Track 3',
                            filePadding: const EdgeInsets.only(top: 0),
                            fileName: Track3Data(
                              fontSize: 17,
                            ),
                            selectButtons: true,
                            selectButton1: true,
                            button1Text: 'Select Track',
                            onPressed1: () {
                              _selectTrack(
                                context,
                                'Track 3',
                                widget.programUID,
                                widget.matchID,
                                'Interview 301',
                                widget.loggedInUser.id,
                              );
                            },
                          ),
                          ProgramGuideCard(
                            titleText: 'Track 4',
                            filePadding: const EdgeInsets.only(top: 0),
                            fileName: Track4Data(),
                            selectButtons: true,
                            selectButton1: true,
                            button1Text: 'Select Track',
                            onPressed1: () {
                              _selectTrack(
                                context,
                                'Track 4',
                                widget.programUID,
                                widget.matchID,
                                'Emotional Intelligence',
                                widget.loggedInUser.id,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 4; i++)
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
        });
  }
}
