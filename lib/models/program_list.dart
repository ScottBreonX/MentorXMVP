import 'package:cached_network_image/cached_network_image.dart';
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
          cachedNetworkImage: CachedNetworkImage(
            imageUrl: program.programLogo,
            imageBuilder: (context, imageProvider) => Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/MLogoBlue.png',
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MentorLaunchScreen(
                  programUID: programUID,
                ),
              ),
            );
          },
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
