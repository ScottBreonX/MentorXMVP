import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_admin/program_admin_stats_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_enrollment_screen.dart';

import '../../../components/rounded_button.dart';
import '../../../models/user.dart';
import '../../authentication/landing_page.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramOverview extends StatefulWidget {
  final myUser loggedInUser;
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
  bool isLoading = false;

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
                      minWidth: 120,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          isLoading = true;
                        });
                        _leaveProgram();
                      },
                    ),
                  ),
                  SimpleDialogOption(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: RoundedButton(
                      title: 'Cancel',
                      buttonColor: Colors.grey,
                      fontColor: Colors.white,
                      minWidth: 120,
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

  _leaveProgram() async {
    //remove all match references from loggedInUser and matches
    var matches = await programsRef
        .doc(widget.programId)
        .collection('userSubscribed')
        .doc(widget.loggedInUser.id)
        .collection('matches')
        .get();

    for (var doc in matches.docs) {
      var reverseMatches = await programsRef
          .doc(widget.programId)
          .collection('userSubscribed')
          .doc(doc.id)
          .collection('matches')
          .where('matchID', isEqualTo: doc['matchID'])
          .get();
      for (var reverseMatch in reverseMatches.docs) {
        await reverseMatch.reference.delete();
      }
      await doc.reference.delete();
    }

    //remove user references within matches
    var userMatches = await programsRef
        .doc(widget.programId)
        .collection('userSubscribed')
        .doc(widget.loggedInUser.id)
        .collection('matches')
        .get();

    for (var doc in userMatches.docs) {
      var userMatchReverse = await programsRef
          .doc(widget.programId)
          .collection('userSubscribed')
          .doc(doc.id)
          .collection('matches')
          .get();

      for (var doc in userMatchReverse.docs) {
        if (doc.id == widget.loggedInUser.id) {
          doc.reference.delete();
        }
      }
    }
    //remove user from any matches with mentors
    var mentorMatches = await programsRef
        .doc(widget.programId)
        .collection('matchedPairs')
        .where('mentee', isEqualTo: widget.loggedInUser.id)
        .get();

    for (var doc in mentorMatches.docs) {
      await doc.reference.delete();
    }

    //remove user from any matches with mentees
    var menteeMatches = await programsRef
        .doc(widget.programId)
        .collection('matchedPairs')
        .where('mentor', isEqualTo: widget.loggedInUser.id)
        .get();

    for (var doc in menteeMatches.docs) {
      await doc.reference.delete();
    }

    //remove user from program subscribers
    await programsRef
        .doc(widget.programId)
        .collection('userSubscribed')
        .doc(widget.loggedInUser.id)
        .delete();

    //remove user from program mentor collection
    await programsRef
        .doc(widget.programId)
        .collection('mentors')
        .doc(widget.loggedInUser.id)
        .delete();

    //remove user from program mentee collection
    await programsRef
        .doc(widget.programId)
        .collection('mentees')
        .doc(widget.loggedInUser.id)
        .delete();

    //remove user reference to program
    await usersRef.doc(widget.loggedInUser.id).update({'Program': ""});

    //Navigate back to home screen
    setState(() {
      isLoading = false;
    });

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(),
        ));
  }

  bool isAdmin = false;

  @override
  void initState() {
    checkIsAdmin();
    super.initState();
  }

  checkIsAdmin() async {
    DocumentSnapshot doc = await programsRef
        .doc(widget.programId)
        .collection('programAdmins')
        .doc(widget.loggedInUser.id)
        .get();
    if (doc.exists) {
      setState(() {
        isAdmin = true;
      });
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: programsRef.doc(widget.programId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress(Theme.of(context).primaryColor);
          }
          Program program = Program.fromDocument(snapshot.data);
          return Scaffold(
            appBar: AppBar(
              elevation: 5,
              backgroundColor: kMentorXPPrimary,
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 35.0, bottom: 10),
                  child: Image.asset(
                    'assets/images/MentorXP.png',
                    fit: BoxFit.contain,
                    height: 35,
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
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
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fitWidth,
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
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10),
                                  child: Text(
                                    'About this program',
                                    style: TextStyle(
                                      fontSize: 25,
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
                                  onPressed: () => _confirmLeaveScreen(
                                      context, widget.programId),
                                ),
                                isAdmin
                                    ? ButtonCard(
                                        buttonCardText: 'Program Admin Tools',
                                        buttonCardTextSize: 25,
                                        buttonCardRadius: 20,
                                        buttonCardIcon:
                                            Icons.admin_panel_settings,
                                        buttonCardIconSize: 40,
                                        buttonCardIconColor: kMentorXPSecondary,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProgramAdminStatsScreen(
                                                loggedInUser:
                                                    widget.loggedInUser,
                                                programUID: program.id,
                                              ),
                                            ),
                                          );
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         ProgramAdminScreen(
                                          //       loggedInUser: widget.loggedInUser,
                                          //       programUID: program.id,
                                          //       aboutProgram: program.aboutProgram,
                                          //       institutionName:
                                          //           program.institutionName,
                                          //       programName: program.programName,
                                          //       programCode: program.programCode,
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                isLoading
                    ? Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.5),
                        child: circularProgress(Colors.white),
                      )
                    : Container(),
              ],
            ),
          );
        });
  }
}
