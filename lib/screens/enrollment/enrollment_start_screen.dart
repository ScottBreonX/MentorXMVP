import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

    Color infoBackground = kMentorXPrimary;
    Color infoText = Colors.white;
    Color infoOutline = kMentorXPrimary;

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
        backgroundColor: kMentorXDark,
        title: Text('Enrollment'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              kMentorXBlack.withOpacity(0.95),
              kMentorXBlack.withOpacity(0.9),
              kMentorXBlack.withOpacity(0.85),
              kMentorXBlack.withOpacity(0.8),
            ])),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Welcome to the enrollment page',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            color: kMentorXPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          color: infoBackground,
                          border: Border.all(
                            color: infoOutline,
                            width: 4.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2.0,
                              offset: Offset(2, 2),
                              color: Colors.white,
                            ),
                          ],
                        ),
                        height: 100.0,
                        width: 150.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'What to expect',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: infoText,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          color: infoBackground,
                          border: Border.all(
                            color: infoOutline,
                            width: 4.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2.0,
                              offset: Offset(2, 2),
                              color: Colors.white,
                            ),
                          ],
                        ),
                        height: 100.0,
                        width: 150.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Mentorship Timeline',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: infoText,
                                fontSize: 20.0,
                              ),
                            ),
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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          color: infoBackground,
                          border: Border.all(
                            color: infoOutline,
                            width: 4.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2.0,
                              offset: Offset(2, 2),
                              color: Colors.white,
                            ),
                          ],
                        ),
                        height: 100.0,
                        width: 150.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Info for Mentees',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: infoText,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2.0,
                              offset: Offset(2, 2),
                              color: Colors.white,
                            ),
                          ],
                          color: infoBackground,
                          border: Border.all(
                            color: infoOutline,
                            width: 4.0,
                          ),
                        ),
                        height: 100.0,
                        width: 150.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Info for Mentors',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: infoText,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedButton(
                    title: 'Proceed to Enrollment -->',
                    buttonColor: kMentorXPrimary,
                    fontColor: Colors.white,
                    fontSize: 20.0,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      EnrollmentSelectionScreen.id,
                    ),
                    minWidth: 350,
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
