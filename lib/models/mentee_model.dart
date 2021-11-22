import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/mentee_card.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';

class Mentee extends StatefulWidget {
  final String menteeUID;

  Mentee({this.menteeUID});

  factory Mentee.fromDocument(DocumentSnapshot doc) {
    return Mentee(menteeUID: doc.id);
  }

  @override
  _MenteeState createState() => _MenteeState(
        menteeUID: this.menteeUID.trim(),
      );
}

class _MenteeState extends State<Mentee> {
  final String menteeUID;

  _MenteeState({this.menteeUID});

  buildMenteeCard() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(menteeUID).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        ProfileModel user = ProfileModel.fromDocument(snapshot.data);
        return MenteeCard(
          user: user,
          primaryTextSize: 30,
          secondaryTextSize: 20,
          boxHeight: 300,
        );
      },
    );
  }

  // GestureDetector(
  // onTap: () {},
  // child: Column(
  // mainAxisAlignment: MainAxisAlignment.center,
  // children: [
  // Padding(
  // padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
  // ),
  // // Image.network(user.photoUrl),
  // ProfileImageCircle(
  // iconSize: 75, circleSize: 100), // image placeholder
  // SizedBox(height: 15.0),
  // Text(
  // user.fName,
  // style: TextStyle(
  // fontSize: 24,
  // color: Colors.black,
  // ),
  // ),
  // Text(user.major,
  // style: TextStyle(
  // fontSize: 18,
  // color: Colors.black,
  // )),
  // ],
  // ),
  // );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildMenteeCard(),
      ],
    );
  }
}
