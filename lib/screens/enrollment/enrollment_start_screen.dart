import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/menu_bar.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/enrollment/enrollment_selection_screen.dart';

User loggedInUser;

class EnrollmentStartScreen extends StatefulWidget {
  static String id = 'enrollment_start_screen';

  @override
  _EnrollmentStartScreenState createState() => _EnrollmentStartScreenState();
}

class _EnrollmentStartScreenState extends State<EnrollmentStartScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
    getProfileData().then((value) => getMentorProfileData());
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
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
        setState(() {
          profileData = result.data();
        });
      });
    });
  }

  dynamic mentorProfileData;

  Future<dynamic> getMentorProfileData() async {
    await FirebaseFirestore.instance
        .collection('users/${profileData['mentorUID']}/profile')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        setState(() {
          mentorProfileData = result.data();
        });
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

    return Scaffold(
      drawer: Drawer(
        child: Container(
          child: drawerItems,
          decoration: BoxDecoration(
            color: kMentorXDark,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: kMentorXDark.withOpacity(0.95),
        title: Text('Enrollment'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: kMentorXDark,
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 8.0, right: 8.0, left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Welcome to the enrollment page',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: kMentorXPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Before you begin, please read the below guides on what to expect',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconCard(
                        cardColor: Colors.white.withOpacity(0.05),
                        cardIconColor: kMentorXPrimary,
                        cardTextColor: Colors.white,
                        cardShadowColor: kMentorXBlack,
                        cardIcon: Icons.assignment,
                        cardText: 'Guide',
                        boxHeight: 120,
                        boxWidth: 120,
                        iconSize: 50,
                        textSize: 15,
                        onTap: () {},
                      ),
                      IconCard(
                        cardColor: Colors.white.withOpacity(0.05),
                        cardIconColor: kMentorXPrimary,
                        cardTextColor: Colors.white,
                        cardShadowColor: kMentorXBlack,
                        cardIcon: Icons.timeline,
                        cardText: 'Expectations',
                        boxHeight: 120,
                        boxWidth: 120,
                        iconSize: 50,
                        textSize: 15,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconCard(
                        cardColor: Colors.white.withOpacity(0.05),
                        cardIconColor: kMentorXPrimary,
                        cardTextColor: Colors.white,
                        cardShadowColor: kMentorXBlack,
                        cardIcon: Icons.calendar_today_rounded,
                        cardText: 'Timeline',
                        boxHeight: 120,
                        boxWidth: 120,
                        iconSize: 50,
                        textSize: 15,
                        onTap: () {},
                      ),
                      IconCard(
                        cardColor: Colors.white.withOpacity(0.05),
                        cardIconColor: kMentorXPrimary,
                        cardTextColor: Colors.white,
                        cardShadowColor: kMentorXBlack,
                        cardIcon: Icons.badge,
                        cardText: 'Roles',
                        boxHeight: 120,
                        boxWidth: 120,
                        iconSize: 50,
                        textSize: 15,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedButton(
                    title: 'Proceed to Enrollment',
                    buttonColor: kMentorXPrimary,
                    fontColor: Colors.white,
                    fontSize: 15.0,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      EnrollmentSelectionScreen.id,
                    ),
                    minWidth: 300,
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
