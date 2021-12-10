import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/services/database.dart';
import '../home_screen.dart';

class SelectionScreen extends StatefulWidget {
  final myUser loggedInUser;

  const SelectionScreen({
    Key key,
    this.database,
    this.loggedInUser,
  }) : super(key: key);

  static const String id = 'selection_screen';
  final Database database;

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
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
        title: Text('Mentor+'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton(
              title: 'Welcome, ${loggedInUser.firstName}!',
              fontSize: 24,
              buttonColor: Colors.blue,
              fontColor: Colors.white,
              onPressed: () => confirmSignOut(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  children: [
                    IconCard(
                      cardIcon: Icons.people,
                      cardColor: Theme.of(context).cardColor,
                      cardText: 'Programs',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(pageIndex: 2),
                        ),
                      ),
                    ),
                    IconCard(
                      cardIcon: Icons.person,
                      cardColor: Theme.of(context).cardColor,
                      cardText: 'My Profile',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(pageIndex: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
