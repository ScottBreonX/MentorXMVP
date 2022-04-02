import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/program_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/available_mentors.dart';
import '../../components/progress.dart';
import '../launch_screen.dart';

class MentorLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;

  const MentorLaunchScreen({
    Key key,
    this.loggedInUser,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: usersRef.doc(loggedInUser.id).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
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
                                Image.asset(
                                  'assets/images/UNILogo.png',
                                  height: 120,
                                ),
                                Text(
                                  'UNI College of Business',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Text(
                                  'Mentorship Program',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline4,
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
                                builder: (context) => AvailableMentorsScreen(
                                  loggedInUser: widget.loggedInUser,
                                ),
                              ),
                            );
                          },
                          minWidth: 300,
                        )
                        // ConnectionCard(
                        //   mentorClass: 'Mentor',
                        //   mentorFName: 'Godric',
                        //   mentorLName: 'Griffindor',
                        // ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 20),
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
                          padding: const EdgeInsets.only(left: 10.0, top: 20),
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
  }
}
