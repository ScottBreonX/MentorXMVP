import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_lauch_screen.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/services/database.dart';

class ProgramSelectionScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'program_selection_screen';
  final Database database;

  const ProgramSelectionScreen({
    this.loggedInUser,
    this.database,
  });

  @override
  _ProgramSelectionScreenState createState() => _ProgramSelectionScreenState();
}

class _ProgramSelectionScreenState extends State<ProgramSelectionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = MentorXMenuList(loggedInUser: loggedInUser);
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
        title: Text('Program Selection'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Wrap(
                children: [
                  IconCard(
                    cardIcon: Icons.add,
                    cardColor: Theme.of(context).cardColor,
                    cardText: 'Join a Program',
                    borderWidth: 3,
                    onTap: () {},
                  ),
                  IconCard(
                    cardText: 'University of Michigan',
                    cardColor: Theme.of(context).cardColor,
                    imageAsset: Image.asset(
                      'assets/images/UMichLogo.png',
                      height: 60,
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, MentorLaunch.id);
                    },
                  ),
                  IconCard(
                    cardText: 'Finance Careers Mentorship',
                    cardColor: Theme.of(context).cardColor,
                    imageAsset: Image.asset(
                      'assets/images/MLogoBlue.png',
                      height: 60,
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, MentorLaunch.id);
                    },
                  ),
                  IconCard(
                    cardText: 'Consulting Careers Mentorship',
                    cardColor: Theme.of(context).cardColor,
                    imageAsset: Image.asset(
                      'assets/images/MLogoBlue.png',
                      height: 60,
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, MentorLaunch.id,
                          arguments: loggedInUser);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
