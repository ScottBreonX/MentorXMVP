import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:provider/provider.dart';

User loggedInUser;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key key,
    this.database,
  }) : super(key: key);

  static const String id = 'notifications_screen';
  final Database database;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
          decoration: BoxDecoration(),
        ),
      ),
      appBar: AppBar(
        elevation: 5,
        title: Text('Notifications'),
      ),
      body: Container(
        child: Center(
          child: Text(
            'Notifications Placeholder',
            style: TextStyle(
              fontFamily: "Signatra",
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}
