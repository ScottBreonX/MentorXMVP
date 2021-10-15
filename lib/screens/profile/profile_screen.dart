import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/profile_card.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:provider/provider.dart';
import 'package:mentorx_mvp/components/about_me.dart';

User loggedInUser;

class MyProfile extends StatefulWidget {
  const MyProfile({
    Key key,
    this.database,
  }) : super(key: key);

  static const String id = 'profile_screen';
  final Database database;

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXPrimary,
        elevation: 5,
        title: Text('My Profile'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            ProfileCard(
                profilePhotoStatus: profilePhotoStatus,
                profileData: profileData),
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
                            Icons.person,
                            color: kMentorXPrimary,
                            size: 30,
                          ),
                          text: 'About Me',
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
                        child: Text('Placeholder for Education Section'),
                      ),
                      Center(
                        child: Text('Placeholder for Education Section'),
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
