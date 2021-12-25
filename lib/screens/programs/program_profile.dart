import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_join_request.dart';

class ProgramProfile extends StatefulWidget {
  final loggedInUser;
  final String programId;
  static String id = 'program_screen';

  const ProgramProfile({
    this.programId,
    this.loggedInUser,
  });

  @override
  State<ProgramProfile> createState() => _ProgramProfileState();
}

class _ProgramProfileState extends State<ProgramProfile> {
  bool hasRequested = false;

  @override
  void initState() {
    super.initState();
    checkHasRequested();
  }

  checkHasRequested() async {
    DocumentSnapshot doc = await programsRef
        .doc(widget.programId)
        .collection('userRequested')
        .doc(loggedInUser.id)
        .get();
    setState(() {
      hasRequested = doc.exists;
    });
  }

  Widget build(BuildContext context) {
    Container buildButton({String text, Function function}) {
      return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: RoundedButton(
          onPressed: function,
          title: text,
          buttonColor: hasRequested
              ? Colors.grey
              : Theme.of(context).buttonTheme.colorScheme.primary,
          fontColor: hasRequested
              ? Colors.grey[700]
              : Theme.of(context).textTheme.button.color,
          fontSize: 24,
          minWidth: MediaQuery.of(context).size.width * 0.77,
        ),
      );
    }

    buildJoinButton(Program program) {
      if (!hasRequested) {
        return buildButton(
          text: "Want to Join?",
          function: () => navigateSecondPage(program),
        );
      } else if (hasRequested) {
        return buildButton(
          text: "You have requested to join.",
          function: () {},
        );
      }
    }

    return FutureBuilder<Object>(
        future: programsRef.doc(widget.programId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          Program program = Program.fromDocument(snapshot.data);
          return Scaffold(
            appBar: AppBar(
              elevation: 5,
              title: Text('${program.programName}'),
            ),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.attach_money_outlined,
                      size: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: Text(
                        '${program.institutionName}\'s \n ${program.programName} Mentorship Program',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Theme.of(context).textTheme.headline1.color,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 8,
                      color: Theme.of(context).dividerColor,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Type of program',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey,
                            ),
                            height: 45,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Text(
                                '${program.enrollmentType.toUpperCase()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .color,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'About this program',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Text(
                                '${program.aboutProgram}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .color,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    buildJoinButton(program),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void refreshData() {
    checkHasRequested();
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  void navigateSecondPage(Program program) {
    Route route = MaterialPageRoute(
      builder: (context) => ProgramJoinRequest(
        loggedInUser: loggedInUser,
        program: program,
      ),
    );
    Navigator.push(context, route).then(onGoBack);
  }
}
