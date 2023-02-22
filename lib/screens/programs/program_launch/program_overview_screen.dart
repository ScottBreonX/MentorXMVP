import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_enrollment_screen.dart';

import '../../../components/rounded_button.dart';
import '../../authentication/landing_page.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramOverview extends StatefulWidget {
  final loggedInUser;
  final String programId;
  static String id = 'program_overview_screen';

  const ProgramOverview({
    this.programId,
    this.loggedInUser,
  });

  @override
  State<ProgramOverview> createState() => _ProgramOverviewState();
}

class _ProgramOverviewState extends State<ProgramOverview> {
  _confirmLeaveScreen(parentContext, programUID) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                'Confirm Leaving Program',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      child: Column(
                        children: [
                          Text(
                            'Are you sure you want to leave the program?',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.black45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleDialogOption(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: RoundedButton(
                      title: 'Yes',
                      buttonColor: kMentorXPSecondary,
                      fontColor: Colors.white,
                      minWidth: 150,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      onPressed: () => _leaveProgram(programUID),
                    ),
                  ),
                  SimpleDialogOption(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: RoundedButton(
                      title: 'Cancel',
                      buttonColor: Colors.grey,
                      fontColor: Colors.white,
                      minWidth: 150,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
                child: Text(
                  'You will lose all program-related mentoring information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        });
  }

  _leaveProgram(programUID) {
    usersRef.doc(widget.loggedInUser.id).update({'Program': ""});
    programsRef
        .doc(programUID)
        .collection('userSubscribed')
        .doc(widget.loggedInUser.id)
        .delete();
    programsRef
        .doc(programUID)
        .collection('mentors')
        .doc(widget.loggedInUser.id)
        .delete();
    programsRef
        .doc(programUID)
        .collection('mentees')
        .doc(widget.loggedInUser.id)
        .delete();
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(),
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
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
                                  height: 150,
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
                                  height: 150,
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
                                    color: Colors.black54,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Divider(
                          thickness: 2,
                          color: Colors.black45,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, bottom: 10),
                              child: Text(
                                'About this program',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
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
                                      color: Colors.black54,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ButtonCard(
                              buttonCardText: 'Leave Program',
                              buttonCardTextSize: 25,
                              buttonCardRadius: 20,
                              buttonCardIcon: Icons.exit_to_app,
                              buttonCardIconSize: 40,
                              buttonCardIconColor: kMentorXPSecondary,
                              onPressed: () =>
                                  _confirmLeaveScreen(context, program.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
