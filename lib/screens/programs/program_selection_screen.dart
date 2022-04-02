import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/programs/available_programs.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_launch_screen.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/services/database.dart';

import '../../components/rounded_button.dart';

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
    final drawerItems = MentorXMenuList(loggedInUser: widget.loggedInUser);
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: RoundedButton(
                  title: 'Join a new program',
                  buttonColor: Colors.pink,
                  fontColor: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AvailableProgramsScreen(
                          loggedInUser: widget.loggedInUser,
                        ),
                      ),
                    );
                  },
                  minWidth: 300,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.check_circle,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Enrolled Programs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 4,
                indent: 40,
                endIndent: 40,
                color: Colors.black45,
              ),
              Wrap(
                children: [
                  IconCard(
                    cardText: 'University of Northern Iowa',
                    textSize: 15,
                    cardTextColor: Colors.black54,
                    cardColor: Theme.of(context).cardColor,
                    imageAsset: Image.asset(
                      'assets/images/UNILogo.png',
                      height: 60,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, MentorLaunchScreen.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
