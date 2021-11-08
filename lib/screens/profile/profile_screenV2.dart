import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/about_me_section.dart';
import 'package:mentorx_mvp/components/menu_bar.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';

User loggedInUser;

class MentorScreen extends StatefulWidget {
  static String id = 'mentor_screen';

  @override
  _MentorScreenState createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
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
                        child: Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 10,
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.edit,
                          color: Colors.pink,
                          size: 20.0,
                        ),
                      ),
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
                    padding: const EdgeInsets.only(left: 15.0, top: 5.0),
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
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey, Colors.grey.shade200],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: AboutMeSection(),
              ),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey,
                      Colors.grey.shade200,
                    ],
                  ),
                ),
              ),
              AboutMeSection(),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey,
                      Colors.grey.shade200,
                    ],
                  ),
                ),
              ),
              AboutMeSection(),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey,
                      Colors.grey.shade200,
                    ],
                  ),
                ),
              ),
              AboutMeSection(),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey,
                      Colors.grey.shade200,
                    ],
                  ),
                ),
              ),
              AboutMeSection(),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey,
                      Colors.grey.shade200,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
