import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/bottom_navigation_bar.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/menu_bar.dart';
import 'package:mentorx_mvp/constants.dart';
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
          backgroundColor: kMentorXPrimary,
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
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    Color cardColor = Colors.white.withOpacity(0.10);
    Color cardIconColor = kMentorXPrimary;
    Color cardTextColor = Colors.white;
    Color cardShadowColor = Colors.black;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          child: drawerItems,
          decoration: BoxDecoration(
            color: kMentorXDark,
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Image.asset(
          'images/XLogoWhite.png',
          height: 50,
        ),
        elevation: 5,
        backgroundColor: kMentorXBlack.withOpacity(0.9),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: kMentorXBlack,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconCard(
                  cardColor: cardColor,
                  cardIconColor: cardIconColor,
                  cardTextColor: cardTextColor,
                  cardText: 'My Profile',
                  cardIcon: Icons.person,
                  cardShadowColor: cardShadowColor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => XBottomNavigationBar(
                        pageIndex: 3,
                      ),
                    ),
                  ),
                ),
                IconCard(
                  cardColor: cardColor,
                  cardIconColor: cardIconColor,
                  cardTextColor: cardTextColor,
                  cardText: 'Mentoring',
                  cardIcon: Icons.people,
                  cardShadowColor: cardShadowColor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => XBottomNavigationBar(
                        pageIndex: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconCard(
                  cardColor: cardColor,
                  cardIconColor: cardIconColor,
                  cardTextColor: cardTextColor,
                  cardText: 'Events',
                  cardIcon: Icons.calendar_today_rounded,
                  cardShadowColor: cardShadowColor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => XBottomNavigationBar(
                        pageIndex: 1,
                      ),
                    ),
                  ),
                ),
                IconCard(
                  cardColor: cardColor,
                  cardIconColor: cardIconColor,
                  cardTextColor: cardTextColor,
                  cardText: 'My University',
                  cardIcon: Icons.school,
                  cardShadowColor: cardShadowColor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => XBottomNavigationBar(
                        pageIndex: 0,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
