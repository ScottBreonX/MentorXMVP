import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_join_request.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_enrollment_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

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
    checkHasJoined();
    print(widget.loggedInUser.id);
  }

  checkHasRequested() async {
    DocumentSnapshot doc = await programsRef
        .doc(widget.programId)
        .collection('userRequested')
        .doc(widget.loggedInUser.id)
        .get();
    setState(() {
      hasRequested = doc.exists;
    });
  }

  checkHasJoined() async {
    DocumentSnapshot doc = await programsRef
        .doc(widget.programId)
        .collection('userSubscribed')
        .doc(widget.loggedInUser.id)
        .get();
    setState(() {
      hasJoined = doc.exists;
    });
  }

  Widget build(BuildContext context) {
    Container buildButton({String text, Function function}) {
      return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: ButtonCard(
          buttonCardText: text,
          onPressed: function,
          cardIconBool: Container(),
          cardAlignment: MainAxisAlignment.center,
          buttonCardColor: hasJoined ? Colors.grey : kMentorXPAccentDark,
          buttonCardTextColor: hasJoined ? Colors.grey.shade600 : Colors.white,
          buttonCardTextSize: 25,
          buttonCardRadius: 20,
        ),
      );
    }

    buildJoinButton(Program program) {
      checkHasJoined();
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
              backgroundColor: kMentorXPPrimary,
              title: Image.asset(
                'assets/images/MentorXP.png',
                height: 100,
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
                        child: program.programLogo.isEmpty ||
                                program.programLogo == null ||
                                program.programLogo == ""
                            ? Image.asset(
                                'assets/images/MXPDark.png',
                                height: 150,
                              )
                            : CachedNetworkImage(
                                imageUrl: program.programLogo,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/images/MXPDark.png',
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
                                      fontSize: 30, color: Colors.black45),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.grey.shade400,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, bottom: 10.0),
                              child: Text(
                                'About this program',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Montserrat',
                                  color: Colors.black45,
                                ),
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
                                      fontFamily: 'Montserrat',
                                      color: Colors.black54,
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
