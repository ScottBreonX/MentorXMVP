import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/article_card.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/enrollment_model.dart';
import 'package:mentorx_mvp/models/match_list.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_enrollment_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_overview_screen.dart';
import '../../../components/icon_circle_single.dart';
import '../../../components/progress.dart';
import '../../launch_screen.dart';
import '../../mentoring/available_mentors.dart';
import '../../menu_bar/menu_bar.dart';
import '../../profile/profile_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;

  static const String id = 'program_launch_screen';

  const ProgramLaunchScreen({
    Key key,
    this.loggedInUser,
    this.programUID,
  }) : super(key: key);

  @override
  _ProgramLaunchScreenState createState() => _ProgramLaunchScreenState();
}

class _ProgramLaunchScreenState extends State<ProgramLaunchScreen> {
  @override
  void initState() {
    super.initState();
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
            .doc(widget.loggedInUser.id)
            .collection('matches')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          } else {
            _snapshot = snapshot.data;
            if (_snapshot.size > 0) {
              matches = _snapshot.docs
                  .map((doc) => MatchList.fromDocument(
                      doc, widget.programUID, widget.loggedInUser))
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
                      .doc(widget.loggedInUser.id)
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
                                    programUID: widget.programUID,
                                    loggedInUser: widget.loggedInUser,
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
                                left: 12.0, right: 15.0, top: 5.0, bottom: 5.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .90,
                              child: Text(
                                'No new matches yet, please check back after matching period has closed',
                                style: TextStyle(
                                  color: kMentorXPAccentDark,
                                  fontFamily: 'MontSerrat',
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

  buildProgramToDoList(
      profileComplete, guidelinesComplete, enrollmentComplete) {
    pageTransition(Widget page, double offSetLow, double offSetHigh) {
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, page) {
          var begin = Offset.fromDirection(offSetLow, offSetHigh);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: page,
          );
        },
      );
    }

    return Container(
      height: 175,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          profileComplete
              ? Container()
              : ArticleCard(
                  articleIcon: Icons.person,
                  articleTitle: 'My Profile',
                  cardRequirement: "Profile Complete",
                  bodyText: 'Finish filling out your mentorship profile',
                  loggedInUser: widget.loggedInUser,
                  programUID: widget.programUID,
                  onTap: () {
                    Navigator.push(
                      context,
                      pageTransition(
                        Profile(
                          loggedInUser: widget.loggedInUser,
                          profileId: widget.loggedInUser.id,
                        ),
                        1.5,
                        1.0,
                      ),
                    );
                  },
                ),
          guidelinesComplete
              ? Container()
              : ArticleCard(
                  loggedInUser: widget.loggedInUser,
                  cardRequirement: "Guidelines Complete",
                  articleIcon: Icons.info,
                  articleTitle: 'Guidelines',
                  bodyText: 'Read through and agree to program guidelines',
                  programUID: widget.programUID,
                ),
          enrollmentComplete
              ? Container()
              : ArticleCard(
                  loggedInUser: widget.loggedInUser,
                  cardRequirement: "Enrollment Complete",
                  articleIcon: Icons.change_circle,
                  articleTitle: 'Enrollment',
                  bodyText: 'Enroll in the program as a mentor or mentee',
                  programUID: widget.programUID,
                ),
        ],
      ),
    );
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

          final drawerItems =
              MentorXMenuList(loggedInUser: widget.loggedInUser);
          final GlobalKey<ScaffoldState> _scaffoldKey =
              new GlobalKey<ScaffoldState>();

          return StreamBuilder<Object>(
              stream: programsRef
                  .doc(widget.programUID)
                  .collection('userSubscribed')
                  .doc(widget.loggedInUser.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }
                EnrollmentModel enrollmentModel =
                    EnrollmentModel.fromDocument(snapshot.data);

                bool programToDoComplete;

                if ((enrollmentModel.profileComplete) &&
                    (enrollmentModel.enrollmentComplete) &&
                    (enrollmentModel.guidelinesComplete)) {
                  programToDoComplete = true;
                } else {
                  programToDoComplete = false;
                }

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
                    title: Center(
                      child: Image.asset(
                        'assets/images/MentorXP.png',
                        height: 100,
                      ),
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
                                                width: 150.0,
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
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                'assets/images/MXPDark.png',
                                                height: 150,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .90,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10.0,
                                                  ),
                                                  child: Text(
                                                    '${program.programName}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 10,
                                  ),
                                  child: Text(
                                    programToDoComplete
                                        ? 'Connections'
                                        : 'Program To-Do List:',
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: programToDoComplete
                                ? buildMatches()
                                : buildProgramToDoList(
                                    enrollmentModel.profileComplete,
                                    enrollmentModel.guidelinesComplete,
                                    enrollmentModel.enrollmentComplete,
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
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 20),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleIconWithText(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Profile(
                                        loggedInUser: widget.loggedInUser,
                                        profileId: widget.loggedInUser.id,
                                      ),
                                    ),
                                  );
                                },
                                cardIcon: Icons.person,
                                textDescription1: 'My',
                                textDescription2: 'Profile',
                              ),
                              CircleIconWithText(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MentoringScreen(
                                        loggedInUser: widget.loggedInUser,
                                        programUID: widget.programUID,
                                      ),
                                    ),
                                  );
                                },
                                cardIcon: Icons.change_circle,
                                textDescription1: 'Mentoring',
                                textDescription2: 'Enrollment',
                              ),
                              CircleIconWithText(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProgramOverview(
                                        programId: widget.programUID,
                                        loggedInUser: widget.loggedInUser,
                                      ),
                                    ),
                                  );
                                },
                                cardIcon: Icons.info,
                                textDescription1: 'Program',
                                textDescription2: 'Info',
                              ),
                              // isAdmin
                              //     ? ButtonCard(
                              //         buttonCardText: 'Program Management',
                              //         buttonCardIcon: Icons.manage_accounts,
                              //         buttonCardTextSize: 25,
                              //         buttonCardTextAlign: TextAlign.start,
                              //         buttonCardRadius: 20,
                              //         buttonCardIconSize: 40,
                              //         buttonCardIconColor: kMentorXPSecondary,
                              //         onPressed: () {
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       ProgramAdminScreen(
                              //                         loggedInUser: loggedInUser,
                              //                         programUID: program.id,
                              //                         enrollmentType:
                              //                             program.enrollmentType,
                              //                         aboutProgram:
                              //                             program.aboutProgram,
                              //                         institutionName:
                              //                             program.institutionName,
                              //                         programName:
                              //                             program.programName,
                              //                         programCode:
                              //                             program.programCode,
                              //                       )));
                              //         },
                              //       )
                              //     : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}

class CircleIconWithText extends StatelessWidget {
  const CircleIconWithText({
    Key key,
    @required this.onTap,
    @required this.cardIcon,
    @required this.textDescription1,
    @required this.textDescription2,
  }) : super(key: key);

  final Function onTap;
  final IconData cardIcon;
  final String textDescription1;
  final String textDescription2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: IconCircleSingle(
              cardHeight: MediaQuery.of(context).size.width * .80 / 3,
              cardWidth: MediaQuery.of(context).size.width * .80 / 3,
              cardIcon: cardIcon,
              cardIconSize: 70,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              textDescription1 ?? '',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black45,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          Text(
            textDescription2 ?? '',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black45,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
