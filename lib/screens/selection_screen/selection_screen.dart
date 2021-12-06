import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:provider/provider.dart';

import '../home_screen.dart';

User loggedInUser;

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({
    Key key,
    this.database,
  }) : super(key: key);

  static const String id = 'selection_screen';
  final Database database;

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
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
        title: Text('Mentor+'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton(
              title: '${loggedInUser.uid}',
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
