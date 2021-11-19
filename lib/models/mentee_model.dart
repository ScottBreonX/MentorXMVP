import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Match extends StatefulWidget {
  final String menteeName;
  final String mentorName;

  Match({this.menteeName, this.mentorName});

  factory Match.fromDocument(DocumentSnapshot doc) {
    return Match(menteeName: doc['menteeUID'], mentorName: doc['mentorUID']);
  }

  @override
  _MatchState createState() => _MatchState(
        menteeName: this.menteeName,
        mentorName: this.mentorName,
      );
}

class _MatchState extends State<Match> {
  final String menteeName;
  final String mentorName;

  _MatchState({this.menteeName, this.mentorName});

  buildMenteeName() {
    return FutureBuilder(future: usersRef.document(ownerId).get(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return circularProgress();
      }
      User user = User.fromDocument(snapshot.data);
      return ListTile(
        title: GestureDetector(
          onTap: (){},
          child: Text(
            user.username,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    })
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildMenteeName(),
      ],
    );
  }
}
