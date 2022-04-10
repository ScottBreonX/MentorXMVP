import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/program_tile.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_launch_screen.dart';

import '../components/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramList extends StatefulWidget {
  final String programUID;

  ProgramList({this.programUID});

  factory ProgramList.fromDocument(DocumentSnapshot doc) {
    return ProgramList(programUID: doc.id);
  }

  @override
  _ProgramListState createState() => _ProgramListState(
        programUID: this.programUID,
      );
}

class _ProgramListState extends State<ProgramList> {
  final String programUID;
  final String programName;

  _ProgramListState({this.programUID, this.programName});

  buildProgramCard() {
    return FutureBuilder<DocumentSnapshot>(
      future: programsRef.doc(programUID).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Program program = Program.fromDocument(snapshot.data);

        return ProgramTile(
          programId: programUID,
          programName: program.programName,
          onPressed: () => Navigator.pushNamed(context, MentorLaunchScreen.id),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildProgramCard(),
      ],
    );
  }
}
