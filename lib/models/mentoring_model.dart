import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/profile_card.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

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
        myUser user = myUser.fromDocument(snapshot.data);
        return ProfileCard(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(profileId: menteeUID),
            ),
          ), // replace with navigation to user profile
          user: user,
          primaryTextSize: 25,
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
