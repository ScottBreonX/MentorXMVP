import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/divider_3D.dart';
import 'package:mentorx_mvp/components/icon_circle.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:provider/provider.dart';

User loggedInUser;

class MentoringScreen extends StatefulWidget {
  const MentoringScreen({
    Key key,
    this.database,
  }) : super(key: key);

  static const String id = 'mentoring_screen';
  final Database database;

  @override
  _MentoringScreenState createState() => _MentoringScreenState();
}

class _MentoringScreenState extends State<MentoringScreen> {
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
        title: Text('MentoringScreen'),
      ),
      // replace body with ListView of mentees
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // replace icon circle with profile pics
                    IconCircle(
                      height: 250.0,
                      width: 250.0,
                      iconSize: 220,
                      iconType: Icons.person,
                      circleColor: Colors.black,
                      iconColor: Colors.white,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Alan Croft',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Mentee',
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider3D(),
            Container(
              child: Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // replace icon circle with profile pics
                  IconCircle(
                    height: 250.0,
                    width: 250.0,
                    iconSize: 220,
                    iconType: Icons.person_outlined,
                    circleColor: Colors.black,
                    iconColor: Colors.white,
                  ),
                  SizedBox(height: 10.0),
                  // replace text with imported names
                  Text(
                    'Scott Breon',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Mentee',
                    style: TextStyle(
                      fontSize: 26.0,
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
