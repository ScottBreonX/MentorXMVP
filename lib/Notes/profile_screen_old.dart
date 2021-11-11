import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:provider/provider.dart';
import 'package:mentorx_mvp/components/about_me.dart';

User loggedInUser;

class OldProfile extends StatefulWidget {
  const OldProfile({
    Key key,
    this.database,
  }) : super(key: key);

  static const String id = 'profile_screen';
  final Database database;

  @override
  _OldProfileState createState() => _OldProfileState();
}

class _OldProfileState extends State<OldProfile> {
  bool aboutMeEditStatus = false;
  bool profilePhotoStatus = false;
  bool profilePhotoSelected = false;
  String aboutMeText;

  @override
  void initState() {
    getCurrentUser();
    getProfileData();
    aboutMeEditStatus = false;
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

  dynamic profileData;

  Future<dynamic> getProfileData() async {
    await FirebaseFirestore.instance
        .collection('users/${loggedInUser.uid}/profile')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (mounted) {
          setState(() {
            profileData = result.data();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (profileData == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: kMentorXPrimary,
        ),
      );
    }

    var drawerHeader = MentorXMenuHeader(
      fName: '${profileData['First Name']}',
      lName: '${profileData['Last Name']}',
      email: '${profileData['Email Address']}',
      profilePicture: '${profileData['images']}',
    );

    final drawerItems = MentorXMenuList(drawerHeader: drawerHeader);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          child: drawerItems,
          decoration: BoxDecoration(
            color: kMentorXPrimary,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: kMentorXPrimary,
        elevation: 5,
        title: Text('My Profile'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 10,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      labelColor: kMentorXPrimary,
                      indicatorColor: kMentorXPrimary,
                      tabs: [
                        Tab(
                          icon: Icon(
                            Icons.people,
                            color: kMentorXPrimary,
                            size: 40,
                          ),
                          text: 'Mentoring',
                        ),
                        Tab(
                          icon: Icon(
                            Icons.work,
                            color: kMentorXPrimary,
                            size: 40,
                          ),
                          text: 'Work',
                        ),
                        Tab(
                          icon: Icon(
                            Icons.school,
                            color: kMentorXPrimary,
                            size: 40,
                          ),
                          text: 'Education',
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      AboutMe(),
                      Center(
                        child: Text(
                          'Placeholder for Work Experience Section',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Signatra',
                            color: Colors.black54,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Placeholder for Education Section',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Signatra',
                            color: Colors.black54,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
