import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/components/bottom_navigation_bar.dart';
import 'package:mentorx_mvp/components/menu_bar.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';

User loggedInUser;

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({this.onSignOut});

  static const String id = 'launch_screen';
  final VoidCallback onSignOut;

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    getCurrentUser();
    getProfileData();
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
    bool profilePictureStatus;

    if (profileData == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: kMentorXTeal,
        ),
      );
    }

    if (profileData['images'] != null) {
      profilePictureStatus = true;
    } else {
      profilePictureStatus = false;
    }

    var drawerHeader = MentorXMenuHeader(
      fName: '${profileData['First Name']}',
      lName: '${profileData['Last Name']}',
      email: '${profileData['Email Address']}',
      profilePicture: '${profileData['images']}',
    );

    final drawerItems = MentorXMenuList(drawerHeader: drawerHeader);

    return Scaffold(
      drawer: Drawer(
        child: Container(
          child: drawerItems,
          decoration: BoxDecoration(
            color: kDrawerItems,
          ),
        ),
      ),
      appBar: AppBar(
        title: Image.asset(
          'images/XLogoWhite.png',
          height: 50,
        ),
        elevation: 0,
        backgroundColor: kMentorXTeal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  offset: Offset(1, 2),
                                  spreadRadius: 1,
                                  color: Colors.grey),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundImage: profilePictureStatus
                                ? NetworkImage(profileData['images'])
                                : null,
                            backgroundColor: kMentorXTeal,
                            radius: 60,
                            child: profilePictureStatus
                                ? null
                                : Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${profileData['First Name']} ${profileData['Last Name']}',
                                  style: TextStyle(
                                    fontSize: 40.0,
                                    color: kMentorXTeal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${profileData['Major']}, ${profileData['Year in School']}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: const Divider(
                    color: kMentorXTeal,
                    height: 20,
                    thickness: 4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1.) Complete Profile',
                        style: TextStyle(
                            fontSize: 20,
                            color: kMentorXTeal,
                            fontWeight: FontWeight.w500),
                      ),
                      RoundedButton(
                        title: 'My Profile',
                        buttonColor: kMentorXTeal,
                        minWidth: 150,
                        fontColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, MyProfile.id);
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => XBottomNavigationBar(
//                                pageIndex: 3,
//                              ),
//                            ),
//                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '2.) View Events',
                        style: TextStyle(
                            fontSize: 20,
                            color: kMentorXTeal,
                            fontWeight: FontWeight.w500),
                      ),
                      RoundedButton(
                        title: 'Events',
                        buttonColor: kMentorXTeal,
                        minWidth: 150,
                        fontColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => XBottomNavigationBar(
                                pageIndex: 1,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '3.) Enroll in Program',
                        style: TextStyle(
                            fontSize: 20,
                            color: kMentorXTeal,
                            fontWeight: FontWeight.w500),
                      ),
                      RoundedButton(
                        title: 'Mentoring',
                        buttonColor: kMentorXTeal,
                        minWidth: 150,
                        fontColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => XBottomNavigationBar(
                                pageIndex: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
