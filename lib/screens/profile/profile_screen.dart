import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/divider_3D.dart';
import 'package:mentorx_mvp/components/icon_circle.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/screens/profile/sections/about_me_section.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/profile/sections/profile_mentee_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/profile_mentor_section.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';

User loggedInUser;

class MyProfile extends StatefulWidget {
  static String id = 'mentor_screen';

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
          backgroundColor: Colors.pink,
        ),
      );
    }

    double circleSize = 55.0;

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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 120.0,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: Image.asset(
                      'assets/images/MentorPink.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 65.0),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: circleSize + 3,
                          backgroundColor: Colors.white,
                          child: ProfileImageCircle(
                            iconSize: circleSize,
                            circleSize: circleSize,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey, offset: Offset(1, 1))
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.photo_camera,
                                color: Colors.grey,
                                size: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: IconCircle(
                          height: 40.0,
                          width: 40.0,
                          iconSize: 30.0,
                          iconType: Icons.edit,
                          circleColor: Colors.transparent,
                          iconColor: Colors.grey,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 10,
                    child: IconCircle(
                      height: 30.0,
                      width: 30.0,
                      iconSize: 20.0,
                      iconType: Icons.edit,
                      circleColor: Colors.white,
                      iconColor: Colors.pink,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                    child: Text(
                      '${profileData['First Name']} ${profileData['Last Name']}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 5.0, bottom: 15.0),
                    child: Text(
                      '${profileData['Year in School']}, ${profileData['Major']}',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'WorkSans',
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              Divider3D(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: AboutMeSection(),
              ),
              Divider3D(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text(
                      'Mentoring Atttributes',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontWeight: FontWeight.bold,
                        color: kMentorXPrimary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              ProfileMentorSection(),
              ProfileMenteeSection(),
            ],
          ),
        ),
      ),
    );
  }
}
