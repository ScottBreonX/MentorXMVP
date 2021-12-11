import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/services/database.dart';

class NotificationScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'notifications_screen';
  final Database database;

  const NotificationScreen({
    this.database,
    this.loggedInUser,
  });

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
