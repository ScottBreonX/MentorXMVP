import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/program_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/available_mentors.dart';
import '../../components/progress.dart';
import '../launch_screen.dart';

class MentorLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;

  const MentorLaunchScreen({
    Key key,
    this.loggedInUser,
    @required this.programUID,
  }) : super(key: key);

  static const String id = 'mentor_launch_screen';

  @override
  _MentorLaunchScreenState createState() => _MentorLaunchScreenState();
}

class _MentorLaunchScreenState extends State<MentorLaunchScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool programLogo = false;

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

                if (program.programLogo != "") {
                  programLogo = true;
                }

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
                                      CachedNetworkImage(
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
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/MLogoBlue.png',
                                          fit: BoxFit.fitHeight,
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
                                                          top: 20.0),
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
                                  cardIconColor: Colors.black45,
                                  cardIcon: Icons.change_circle,
                                  cardText: 'Enrollment',
                                  textSize: 15,
                                  cardTextColor: Colors.black45,
                                ),
                                IconCard(
                                  cardColor: Colors.white,
                                  boxHeight: 110,
                                  boxWidth: 110,
                                  iconSize: 50,
                                  cardIconColor: Colors.black45,
                                  cardIcon: Icons.email_rounded,
                                  cardText: 'Contact Admin',
                                  textSize: 15,
                                  cardTextColor: Colors.black45,
                                ),
                                IconCard(
                                  cardColor: Colors.white,
                                  boxHeight: 110,
                                  boxWidth: 110,
                                  iconSize: 50,
                                  cardIconColor: Colors.black45,
                                  cardIcon: Icons.info_rounded,
                                  cardText: 'Program Info',
                                  textSize: 15,
                                  cardTextColor: Colors.black45,
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
