import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/program_tile.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';

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
          return circularProgress(Theme.of(context).primaryColor);
        }
        Program program = Program.fromDocument(snapshot.data);

        return ProgramTile(
          boxHeight: 500,
          boxWidth: MediaQuery.of(context).size.width * 0.90,
          programId: programUID,
          programName: program.programName,
          institutionName: program.institutionName,
          programAbout: program.aboutProgram,
          imageContainer: Container(
            child: program.programLogo == null ||
                    program.programLogo.isEmpty ||
                    program.programLogo == ""
                ? Image.asset(
                    'assets/images/MXPDark.png',
                    height: 60,
                    fit: BoxFit.fill,
                  )
                : CachedNetworkImage(
                    imageUrl: program.programLogo,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/MLogoBlue.png',
                      height: 70,
                      width: 70,
                      fit: BoxFit.fill,
                    ),
                  ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProgramLaunchScreen(
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
