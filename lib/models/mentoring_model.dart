import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[],
    );
  }
}
