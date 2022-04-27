import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/mentor_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_launch_screen.dart';
import '../components/profile_image_circle.dart';
import '../components/progress.dart';
import '../screens/launch_screen.dart';
import '../screens/programs/program_launch/program_launch_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MatchList extends StatefulWidget {
  final String matchUID;
  final String programUID;

  MatchList({this.matchUID, this.programUID});

  factory MatchList.fromDocument(DocumentSnapshot doc, String programUID) {
    return MatchList(matchUID: doc.id, programUID: programUID);
  }

  @override
  _MatchListState createState() => _MatchListState(
        matchUID: this.matchUID,
      );
}

class _MatchListState extends State<MatchList> {
  final String matchUID;

  _MatchListState({this.matchUID});

  _confirmRemoveMentor(parentContext, mentorUID, programUID) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                'Confirm Removing Mentor',
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      child: Column(
                        children: [
                          Text(
                            'Are you sure you want to remove this mentor?',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleDialogOption(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: RoundedButton(
                      title: 'Yes',
                      buttonColor: Colors.pink,
                      fontColor: Colors.white,
                      minWidth: 120,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      onPressed: () =>
                          _removeMentor(widget.programUID, matchUID),
                    ),
                  ),
                  SimpleDialogOption(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: RoundedButton(
                      title: 'Cancel',
                      buttonColor: Colors.pink,
                      fontColor: Colors.white,
                      minWidth: 120,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
                child: Text(
                  'You will lose all related mentoring information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        });
  }

  _removeMentor(programUID, matchUID) {
    programsRef
        .doc(programUID)
        .collection('userSubscribed')
        .doc(loggedInUser.id)
        .collection('matchedMentors')
        .doc(matchUID)
        .delete();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgramLaunchScreen(
          programUID: programUID,
        ),
      ),
    );
  }

  buildMatchCard() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(matchUID).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        myUser user = myUser.fromDocument(snapshot.data);

        return Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MentoringLaunchScreen(
                      programUID: widget.programUID,
                      mentorUID: user.id,
                      loggedInUser: loggedInUser,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: MentorCard(
                  mentorUID: user.id,
                  mentorFname: user.firstName,
                  mentorLname: user.lastName,
                  imageContainer: Container(
                    child: user.profilePicture == null ||
                            user.profilePicture.isEmpty ||
                            user.profilePicture == ""
                        ? ProfileImageCircle(
                            circleColor: Colors.blue,
                            iconSize: 45,
                            iconColor: Colors.white,
                            circleSize: 40,
                          )
                        : CircleAvatar(
                            radius: 40,
                            child: CachedNetworkImage(
                              imageUrl: user.profilePicture,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  mentorMajor: user.major,
                  mentorYearInSchool: user.yearInSchool,
                  moreInfoExpand: Container(),

                  // Container(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       RoundedButton(
                  //           title: 'View Profile',
                  //           buttonColor: Colors.pink,
                  //           fontColor: Colors.white,
                  //           minWidth: 150,
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.bold,
                  //           onPressed: () {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) => Profile(
                  //                   profileId: user.id,
                  //                 ),
                  //               ),
                  //             );
                  //           }),
                  //       RoundedButton(
                  //           title: 'Remove',
                  //           buttonColor: Colors.white,
                  //           fontColor: Colors.pink,
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.bold,
                  //           minWidth: 150,
                  //           onPressed: () {
                  //             _confirmRemoveMentor(context, user.id, widget.programUID);
                  //           }),
                  //     ],
                  //   ),
                  // ),
                  dividerExpand: Divider(
                    color: Colors.white,
                    height: 0,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildMatchCard(),
      ],
    );
  }
}
