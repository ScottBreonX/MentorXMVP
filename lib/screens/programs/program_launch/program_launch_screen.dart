import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/enrollment_model.dart';
import 'package:mentorx_mvp/models/match_list.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/home_screen/home_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_admin_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_enrollment_screen.dart';
import '../../../components/progress.dart';
import '../../launch_screen.dart';
import '../../mentoring/available_mentors.dart';
import '../../menu_bar/menu_bar.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;

  const ProgramLaunchScreen({
    Key key,
    this.loggedInUser,
    this.programUID,
  }) : super(key: key);

  static const String id = 'program_launch_screen';

  @override
  _ProgramLaunchScreenState createState() => _ProgramLaunchScreenState();
}

class _ProgramLaunchScreenState extends State<ProgramLaunchScreen> {
  @override
  void initState() {
    super.initState();
    checkIsAdmin();
  }

  bool isLoading = false;
  bool hasMatches = false;
  bool isAdmin = false;
  List<MatchList> matches = [];

  checkIsAdmin() async {
    DocumentSnapshot doc = await programsRef
        .doc(widget.programUID)
        .collection('programAdmins')
        .doc(loggedInUser.id)
        .get();
    if (doc.exists) {
      setState(() {
        isAdmin = true;
      });
    }
  }

  buildMatches() {
    isLoading = true;
    QuerySnapshot _snapshot;
    return FutureBuilder(
        future: programsRef
            .doc(widget.programUID)
            .collection('userSubscribed')
            .doc(loggedInUser.id)
            .collection('matches')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          } else {
            _snapshot = snapshot.data;
            if (_snapshot.size > 0) {
              matches = _snapshot.docs
                  .map((doc) => MatchList.fromDocument(doc, widget.programUID))
                  .toList();
              return Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: matches,
                ),
              );
            } else {
              return StreamBuilder<Object>(
                  stream: programsRef
                      .doc(widget.programUID)
                      .collection('userSubscribed')
                      .doc(loggedInUser.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                    EnrollmentModel enrollmentModel =
                        EnrollmentModel.fromDocument(snapshot.data);

                    if (enrollmentModel.enrollmentStatus == '') {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonCard(
                            buttonCardText: 'Finish Enrollment',
                            buttonCardTextSize: 25,
                            buttonCardRadius: 20,
                            buttonCardIconSize: 40,
                            buttonCardColor: kMentorXPAccentDark,
                            buttonCardTextColor: Colors.white,
                            cardAlignment: MainAxisAlignment.center,
                            cardIconBool: Container(),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MentoringScreen(
                                    loggedInUser: loggedInUser,
                                    programUID: widget.programUID,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    if (enrollmentModel.enrollmentStatus == 'mentor') {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 15.0, top: 5.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .90,
                              child: Text(
                                'No new matches yet, please check back after matching period has closed',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonCard(
                            buttonCardText: 'View Available Mentors',
                            buttonCardTextSize: 25,
                            buttonCardRadius: 20,
                            buttonCardIconSize: 40,
                            buttonCardColor: kMentorXPSecondary,
                            buttonCardTextColor: Colors.white,
                            cardAlignment: MainAxisAlignment.center,
                            cardIconBool: Container(),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AvailableMentorsScreen(
                                    loggedInUser: widget.loggedInUser,
                                    programUID: widget.programUID,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  });
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: programsRef.doc(widget.programUID).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          Program program = Program.fromDocument(snapshot.data);

          final drawerItems = MentorXMenuList(loggedInUser: loggedInUser);
          final GlobalKey<ScaffoldState> _scaffoldKey =
              new GlobalKey<ScaffoldState>();

          return Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              child: Container(
                color: kMentorXPPrimary,
                child: drawerItems,
              ),
            ),
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                program.programLogo == null ||
                                        program.programLogo.isEmpty ||
                                        program.programLogo == ""
                                    ? Image.asset(
                                        'assets/images/MXPDark.png',
                                        height: 150,
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: program.programLogo,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 150.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            circularProgress(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/MXPDark.png',
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .90,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10.0,
                                            ),
                                            child: Text(
                                              '${program.programName}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 10,
                          ),
                          child: Text(
                            'Connections',
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Montserrat',
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    buildMatches(),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 20),
                          child: Text(
                            'Resources',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Column(
                        children: [
                          ButtonCard(
                            buttonCardText: 'Mentoring Enrollment',
                            buttonCardIcon: Icons.change_circle,
                            buttonCardTextSize: 20,
                            buttonCardRadius: 20,
                            buttonCardIconSize: 40,
                            buttonCardIconColor: kMentorXPSecondary,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MentoringScreen(
                                    loggedInUser: loggedInUser,
                                    programUID: widget.programUID,
                                  ),
                                ),
                              );
                            },
                          ),
                          ButtonCard(
                            buttonCardText: 'Program Info',
                            buttonCardIcon: Icons.info,
                            buttonCardTextSize: 20,
                            buttonCardRadius: 20,
                            buttonCardIconSize: 40,
                            buttonCardIconColor: kMentorXPSecondary,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProgramEnrollmentScreen(
                                    loggedInUser: loggedInUser,
                                    programUID: program.id,
                                  ),
                                ),
                              );
                            },
                          ),
                          isAdmin
                              ? ButtonCard(
                                  buttonCardText: 'Program Management',
                                  buttonCardIcon: Icons.manage_accounts,
                                  buttonCardTextSize: 20,
                                  buttonCardRadius: 20,
                                  buttonCardIconSize: 40,
                                  buttonCardIconColor: kMentorXPSecondary,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProgramAdminScreen(
                                                  loggedInUser: loggedInUser,
                                                  programUID: program.id,
                                                  enrollmentType:
                                                      program.enrollmentType,
                                                  aboutProgram:
                                                      program.aboutProgram,
                                                  institutionName:
                                                      program.institutionName,
                                                  programName:
                                                      program.programName,
                                                  programCode:
                                                      program.programCode,
                                                )));
                                  },
                                )
                              : Container(),
                          ButtonCard(
                            buttonCardText: 'Back to Home Screen',
                            buttonCardIcon: Icons.keyboard_return,
                            buttonCardTextSize: 20,
                            buttonCardRadius: 20,
                            buttonCardIconSize: 40,
                            buttonCardIconColor: kMentorXPSecondary,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
