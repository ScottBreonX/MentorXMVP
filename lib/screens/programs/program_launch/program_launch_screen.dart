import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/program_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/available_mentors.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_admin_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_enrollment_screen.dart';
import '../../../components/progress.dart';
import '../../launch_screen.dart';
import '../../menu_bar/menu_bar.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: programsRef.doc(widget.programUID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          Program program = Program.fromDocument(snapshot.data);

          return FutureBuilder<Object>(
              future: usersRef.doc(loggedInUser.id).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }
                final drawerItems =
                    MentorXMenuList(loggedInUser: widget.loggedInUser);
                final GlobalKey<ScaffoldState> _scaffoldKey =
                    new GlobalKey<ScaffoldState>();

                return Scaffold(
                  key: _scaffoldKey,
                  drawer: Drawer(
                    child: Container(
                      child: drawerItems,
                    ),
                  ),
                  appBar: AppBar(
                    elevation: 5,
                    title: Image.asset(
                      'assets/images/MentorPinkWhite.png',
                      height: 150,
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
                                              'assets/images/MLogoPink.png',
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: program.programLogo,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: 120.0,
                                                width: 120,
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
                                                'assets/images/MLogoBlue.png',
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                      Container(
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: Text(
                                                    '${program.programName}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'WorkSans',
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RoundedButton(
                                title: 'View Available Mentors',
                                buttonColor: Colors.pink,
                                fontColor: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AvailableMentorsScreen(
                                        loggedInUser: widget.loggedInUser,
                                      ),
                                    ),
                                  );
                                },
                                minWidth: 300,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 20),
                                child: Text(
                                  'Program Guides',
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: 120,
                            child: ListView(
                              children: [
                                Container(
                                  height: 120.0,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ProgramCard(
                                        programStartDate: 'This Week',
                                        programEndDate: '',
                                        programName: 'Resume 101',
                                      ),
                                      ProgramCard(
                                        programStartDate: 'Next Week',
                                        programEndDate: '',
                                        programName: 'Initial Chat',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 20),
                                child: Text(
                                  'Resources',
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: 120.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconCard(
                                  cardColor: Colors.white,
                                  boxHeight: 110,
                                  boxWidth: 110,
                                  iconSize: 50,
                                  cardIconColor: Colors.blue,
                                  cardIcon: Icons.change_circle,
                                  cardText: 'Mentoring Enrollment',
                                  textSize: 15,
                                  cardTextColor: Colors.blue,
                                  onTap: () {
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
                                IconCard(
                                  cardColor: Colors.white,
                                  boxHeight: 110,
                                  boxWidth: 110,
                                  iconSize: 50,
                                  cardIconColor: Colors.blue,
                                  cardIcon: Icons.info_rounded,
                                  cardText: 'Program Enrollment',
                                  textSize: 15,
                                  cardTextColor: Colors.blue,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProgramEnrollmentScreen(
                                          loggedInUser: loggedInUser,
                                          programUID: program.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconCard(
                                  onTap: () {
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
                                  cardColor: Colors.white,
                                  boxHeight: 110,
                                  boxWidth: 110,
                                  iconSize: 50,
                                  cardIconColor: Colors.blue,
                                  cardIcon: Icons.admin_panel_settings,
                                  cardText: 'Program Admin',
                                  textSize: 15,
                                  cardTextColor: Colors.blue,
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
        });
  }
}
