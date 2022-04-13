import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
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
  bool hasJoined = false;

  @override
  void initState() {
    super.initState();
    // checkHasRequested();
    checkHasJoined();
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

  checkHasJoined() async {
    DocumentSnapshot doc = await programsRef
        .doc(widget.programId)
        .collection('userSubscribed')
        .doc(loggedInUser.id)
        .get();
    setState(() {
      hasJoined = doc.exists;
    });
  }

  Widget build(BuildContext context) {
    Container buildButton({String text, Function function}) {
      return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: RoundedButton(
          onPressed: function,
          title: text,
          // buttonColor: hasRequested
          //     ? Colors.grey
          //     : Theme.of(context).buttonTheme.colorScheme.primary,
          buttonColor: hasJoined
              ? Colors.grey
              : Theme.of(context).buttonTheme.colorScheme.primary,
          // fontColor: hasRequested
          //     ? Colors.grey[700]
          //     : Theme.of(context).textTheme.button.color,
          fontColor: hasJoined
              ? Colors.grey[700]
              : Theme.of(context).textTheme.button.color,
          fontSize: 24,
          minWidth: MediaQuery.of(context).size.width * 0.77,
        ),
      );
    }

    // buildJoinButton(Program program) {
    //   if (!hasRequested) {
    //     return buildButton(
    //       text: "Want to Join?",
    //       function: () => navigateSecondPage(program),
    //     );
    //   } else if (hasRequested) {
    //     return buildButton(
    //       text: "You have requested to join.",
    //       function: () {},
    //     );
    //   }
    // }

    buildJoinButton(Program program) {
      if (!hasJoined) {
        return buildButton(
          text: "Want to Join?",
          function: () => navigateSecondPage(program),
        );
      } else if (hasJoined) {
        return buildButton(
          text: "You have already joined.",
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
              title: Image.asset(
                'assets/images/MentorPinkWhite.png',
                height: 150,
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CachedNetworkImage(
                          imageUrl: program.programLogo,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/MLogoBlue.png',
                            height: 120,
                            width: 120,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '${program.programName}',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
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
                      Divider(
                        thickness: 6,
                        color: Colors.black45,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 10),
                              child: Text(
                                'Type of program',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[200],
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
                              height: 150,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    '${program.aboutProgram}',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .color,
                                    ),
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
            ),
          );
        });
  }

  void refreshData() {
    // checkHasRequested();
    checkHasJoined();
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
