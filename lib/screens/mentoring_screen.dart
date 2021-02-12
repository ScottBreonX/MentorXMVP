import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/bottom_navigation_bar.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/mentoring_model.dart';
import 'package:mentorx_mvp/screens/mentee_screen.dart';
import 'package:mentorx_mvp/screens/profile_screen.dart';
import 'package:mentorx_mvp/services/database.dart';

import 'chat_screen.dart';
import 'mentor_chat_screen.dart';

User loggedInUser;

class MentoringScreen extends StatefulWidget {
  static String id = 'mentoring_screen';

  @override
  _MentoringScreenState createState() => _MentoringScreenState();
}

class _MentoringScreenState extends State<MentoringScreen> {
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

  Future<void> _createMentor(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: loggedInUser.uid);
      await database.createMentor(
        MentorModel(
          availableSlots: 1,
          uid: loggedInUser.uid,
          fName: profileData['First Name'],
          lName: profileData['Last Name'],
          email: profileData['Email Address'],
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  Future<void> _createMentee(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: loggedInUser.uid);
      await database.createMentee(
        MenteeModel(
          uid: loggedInUser.uid,
          fName: profileData['First Name'],
          lName: profileData['Last Name'],
          email: profileData['Email Address'],
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
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
          backgroundColor: kMentorXTeal,
        ),
      );
    }
    if (profileData['mentorUID'] == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kMentorXTeal,
          title: Text('Mentoring'),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundedButton(
                    onPressed: () async {
                      await _createMentee(context).then((value) =>
                          Navigator.pushNamed(context, MenteeScreen.id));
                    },
                    minWidth: 500.0,
                    title: 'Enroll as Mentee',
                    buttonColor: kMentorXTeal,
                    fontColor: Colors.white,
                  ),
                  RoundedButton(
                    onPressed: () async {
                      await _createMentor(context);
                    },
                    minWidth: 500.0,
                    title: 'Enroll as Mentor',
                    buttonColor: kMentorXTeal,
                    fontColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      if (profileData == null || mentorProfileData == null) {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: kMentorXTeal,
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kMentorXTeal,
          title: Text('Mentoring'),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ProfileImageCircle(circleSize: 50),
                            ),
                            Row(
                              children: [
                                Text(
                                  profileData['First Name'],
                                  style: TextStyle(
                                      color: kMentorXTeal, fontSize: 20.0),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  profileData['Last Name'],
                                  style: TextStyle(
                                      color: kMentorXTeal, fontSize: 20.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ProfileImageCircle(circleSize: 50),
                            ),
                            Row(
                              children: [
                                Text(
                                  mentorProfileData['First Name'],
                                  style: TextStyle(
                                      color: kMentorXTeal, fontSize: 20.0),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  mentorProfileData['Last Name'],
                                  style: TextStyle(
                                      color: kMentorXTeal, fontSize: 20.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: const Divider(
                      color: kMentorXTeal,
                      height: 20,
                      thickness: 4,
                      indent: 0,
                      endIndent: 0,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: kMentorXTeal,
                              child: Icon(
                                Icons.pending_actions,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Goals',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: kMentorXTeal,
                              child: Icon(
                                Icons.calendar_today_rounded,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Events',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: kMentorXTeal,
                              child: Icon(
                                Icons.menu_book,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Guides',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, MentorChatScreen.id);
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: kMentorXTeal,
                              child: Icon(
                                Icons.chat_bubble,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Chat',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
