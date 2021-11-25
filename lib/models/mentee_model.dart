import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/mentee_card.dart';
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
        menteeUID: this.menteeUID,
      );
}

class _MenteeState extends State<Mentee> {
  final String menteeUID;

  _MenteeState({this.menteeUID});

  buildMenteeCard() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(menteeUID.trim()).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        ProfileModel user = ProfileModel.fromDocument(snapshot.data);
        return MenteeCard(
          onTap: () =>
              Navigator.pop(context), // replace with navigation to user profile
          user: user,
          primaryTextSize: 30,
          secondaryTextSize: 20,
          boxHeight: 300,
        );
      },
    );
  }

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
