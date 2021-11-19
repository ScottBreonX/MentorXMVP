import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/divider_3D.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:provider/provider.dart';

User loggedInUser;

class MentorLaunch extends StatefulWidget {
  const MentorLaunch({
    Key key,
    this.database,
  }) : super(key: key);

  static const String id = 'mentor_launch_screen';
  final Database database;

  @override
  _MentorLaunchState createState() => _MentorLaunchState();
}

class _MentorLaunchState extends State<MentorLaunch> {
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

    if (profileData['images'] == null) {
      setState(() {
        profilePhotoStatus = false;
      });
    } else {
      setState(() {
        profilePhotoStatus = true;
      });
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
        title: Text('Mentoring'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Image.asset('assets/images/MLogoBlue.png'),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        'UNIVERSITY OF MICHIGAN',
                        style: TextStyle(
                          fontSize: 24,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider3D(),
            SizedBox(height: 15.0),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: IconCard(
                              cardColor: Colors.grey[800],
                              cardIconColor: Colors.white,
                              cardTextColor: Colors.white,
                              cardText: 'Mentoring',
                              cardIcon: Icons.group,
                              boxHeight: 200,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MentoringScreen(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconCard(
                            cardColor: Colors.grey[800],
                            cardIconColor: Colors.white,
                            cardTextColor: Colors.white,
                            cardText: 'News Feed',
                            cardIcon: Icons.article_outlined,
                            boxHeight: 200,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LaunchScreen(pageIndex: 0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: IconCard(
                            cardColor: Colors.grey[800],
                            cardIconColor: Colors.white,
                            cardTextColor: Colors.white,
                            cardText: 'Calendar',
                            cardIcon: Icons.date_range,
                            boxHeight: 200,
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: IconCard(
                            cardColor: Colors.grey[800],
                            cardIconColor: Colors.white,
                            cardTextColor: Colors.white,
                            cardText: 'Program Info',
                            cardIcon: Icons.info_outline,
                            boxHeight: 200,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
