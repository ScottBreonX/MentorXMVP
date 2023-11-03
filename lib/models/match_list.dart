import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/match_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_launch_screen.dart';
import '../components/profile_image_circle.dart';
import '../components/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MatchList extends StatefulWidget {
  final String mentorUID;
  final String programUID;
  final myUser loggedInUser;

  MatchList({this.mentorUID, this.programUID, this.loggedInUser});

  factory MatchList.fromDocument(
      DocumentSnapshot doc, String programUID, myUser loggedInUser) {
    return MatchList(
      mentorUID: doc.id,
      programUID: programUID,
      loggedInUser: loggedInUser,
    );
  }

  @override
  _MatchListState createState() => _MatchListState(
        mentorUID: this.mentorUID,
        programUID: this.programUID,
        loggedInUser: this.loggedInUser,
      );
}

class _MatchListState extends State<MatchList> {
  final String mentorUID;
  final String programUID;
  final myUser loggedInUser;

  _MatchListState({this.mentorUID, this.programUID, this.loggedInUser});

  buildMatchCard() {
    return FutureBuilder<DocumentSnapshot>(
        future: programsRef
            .doc(widget.programUID)
            .collection('userSubscribed')
            .doc(widget.loggedInUser.id)
            .collection('matches')
            .doc(widget.mentorUID)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
                width: 100,
                height: 100,
                child: circularProgress(Theme.of(context).primaryColor));
          }
          MatchModel matchModel = MatchModel.fromDocument(snapshot.data);

          return FutureBuilder<DocumentSnapshot>(
            future: usersRef.doc(widget.mentorUID).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    width: 100,
                    height: 100,
                    child: circularProgress(Theme.of(context).primaryColor));
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
                            matchID: matchModel.matchID,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                      ),
                      child: Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 35,
                                child: Container(
                                  child: user.profilePicture == null ||
                                          user.profilePicture.isEmpty ||
                                          user.profilePicture == ""
                                      ? ProfileImageCircle(
                                          circleColor: kMentorXPPrimary,
                                          iconSize: 45,
                                          iconColor: Colors.white,
                                          circleSize: 40,
                                        )
                                      : CircleAvatar(
                                          radius: 40,
                                          child: CachedNetworkImage(
                                            imageUrl: user.profilePicture,
                                            imageBuilder:
                                                (context, imageProvider) =>
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
                                            errorWidget:
                                                (context, url, error) => Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Container(
                                width: 150,
                                child: Text(
                                  '${user.firstName}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                              Container(
                                width: 150,
                                child: Text(
                                  '${user.lastName}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildMatchCard(),
      ],
    );
  }
}
