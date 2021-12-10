import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/available_mentors.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/services/database.dart';

class MentorLaunch extends StatefulWidget {
  final myUser loggedInUser;

  MentorLaunch({
    this.database,
    this.loggedInUser,
  });

  static const String id = 'mentor_launch_screen';
  final Database database;

  @override
  _MentorLaunchState createState() => _MentorLaunchState();
}

class _MentorLaunchState extends State<MentorLaunch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = MentorXMenuList();
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
        title: Text('Mentoring'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Image.asset(
                        'assets/images/UMichLogo.png',
                        height: 200,
                      ),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        'University of Michigan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mentorship Program',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 15.0),
            Column(
              children: [
                Wrap(
                  children: [
                    Container(
                      child: IconCard(
                        cardText: 'Mentoring',
                        cardIcon: Icons.group,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MentoringScreen(),
                          ),
                        ),
                      ),
                    ),
                    IconCard(
                      cardText: 'News Feed',
                      cardIcon: Icons.article_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(pageIndex: 0),
                        ),
                      ),
                    ),
                    IconCard(
                      cardText: 'Calendar',
                      cardIcon: Icons.date_range,
                      onTap: () {},
                    ),
                    IconCard(
                      cardText: 'Program Info',
                      cardIcon: Icons.info_outline,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvailableMentorsScreen(
                            loggedInUser: widget.loggedInUser,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
