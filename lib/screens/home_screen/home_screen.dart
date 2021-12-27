import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/program_card.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import '../../components/connection_card.dart';
import '../../components/progress.dart';
import '../launch_screen.dart';

class HomeScreen extends StatefulWidget {
  final myUser loggedInUser;

  const HomeScreen({
    Key key,
    this.loggedInUser,
  }) : super(key: key);

  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = MentorXMenuList(loggedInUser: loggedInUser);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return FutureBuilder<Object>(
        future: usersRef.doc(loggedInUser.id).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              child: Container(
                child: drawerItems,
              ),
            ),
            appBar: AppBar(
              elevation: 5,
              title: Text('Mentor+'),
            ),
            body: Container(
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
                          child: Text(
                            'Welcome Back, ${loggedInUser.firstName}',
                            style: Theme.of(context).textTheme.headline1,
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
                      ConnectionCard(
                        mentorClass: 'Mentor',
                        mentorFName: 'Godric',
                        mentorLName: 'Griffindor',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConnectionCard(
                        mentorClass: 'Mentee',
                        mentorClassTextColor: Colors.green,
                        mentorFName: 'Helga',
                        mentorLName: 'Hufflepuff',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConnectionCard(
                        mentorClass: 'Mentee',
                        mentorClassTextColor: Colors.green,
                        mentorFName: 'Salazar',
                        mentorLName: 'Slytherin',
                      ),
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
                    height: 150,
                    child: ListView(
                      children: [
                        Container(
                          height: 150.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ProgramCard(
                                programIcon: Icons.assignment_rounded,
                                programTiming: 'This Week',
                                programTitle: 'Resume 101',
                                bodyText:
                                    'Build a resume that will help you stand out and land interviews',
                              ),
                              ProgramCard(
                                programIcon: Icons.chat,
                                programTiming: 'Next Week',
                                programTitle: 'Initial Chat',
                                bodyText:
                                    'Start an intro chat with your mentor',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
