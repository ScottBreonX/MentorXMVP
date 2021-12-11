import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/custom_dialog.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/Notes/mentoring_model.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/services/database.dart';

import 'mentee_screen_old.dart';
import 'mentor_screen_old.dart';

User tempUser;

class MentoringScreenOld extends StatefulWidget {
  static String id = 'mentoring_screen_old';

  @override
  _MentoringScreenOldState createState() => _MentoringScreenOldState();
}

class _MentoringScreenOldState extends State<MentoringScreenOld> {
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
        tempUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _createMentor(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: tempUser.uid);
      await database.createMentor(
        MentorModel(
          availableSlots: 1,
          uid: tempUser.uid,
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
      final database = FirestoreDatabase(uid: tempUser.uid);
      await database.createMentee(
        MenteeModel(
          uid: tempUser.uid,
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
        .collection('users/${tempUser.uid}/profile')
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

  Color _mentorBackgroundColor = Colors.grey;
  Color _mentorBorderColor = Colors.grey;
  Color _mentorShadowColor = Colors.white;
  double _mentorBorderWidth = 0;
  double _mentorShadowBlur = 0.0;

  Color _menteeBackgroundColor = Colors.grey;
  Color _menteeBorderColor = Colors.grey;
  Color _menteeShadowColor = Colors.white;
  double _menteeShadowBlur = 0;
  double _menteeBorderWidth = 0;

  Color _nextButtonColor = Colors.grey;
  String _enrollmentSelection = 'Nothing';
  Color _errorTextColor = Colors.white;

  Future<void> _confirmMentorEnrollment(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              title: 'Mentor Enrollment',
              descriptions: 'Confirm enrollment as mentor?',
              textLeft: '<-- Go Back',
              textRight: 'Yes',
              leftOnPressed: () {
                Navigator.pop(context);
              },
              rightOnPressed: () {
                _createMentor(context).then((value) =>
                    Navigator.pushNamed(context, MentorScreenOld.id));
              });
        });
  }

  Future<void> _confirmMenteeEnrollment(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              title: 'Mentee Enrollment',
              descriptions: 'Confirm enrollment as mentee?',
              textLeft: '<-- Go Back',
              textRight: 'Yes',
              leftOnPressed: () {
                Navigator.pop(context);
              },
              rightOnPressed: () {
                _createMentee(context).then((value) =>
                    Navigator.pushNamed(context, MenteeScreenOld.id));
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

    final drawerItems = MentorXMenuList();
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
        title: Text('Mentoring'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    'Select your enrollment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _enrollmentSelection = 'Mentee';
                        setState(() {
                          _nextButtonColor = kMentorXPrimary;
                          _errorTextColor = Colors.white;

                          _menteeBackgroundColor = kMentorXPrimary;
                          _menteeBorderWidth = 4.0;
                          _menteeBorderColor = Colors.greenAccent;
                          _menteeShadowBlur = 2.0;
                          _menteeShadowColor = Colors.grey;

                          _mentorBackgroundColor = Colors.grey;
                          _mentorBorderWidth = 0.0;
                          _mentorBorderColor = Colors.grey;
                          _mentorShadowBlur = 0.0;
                          _mentorShadowColor = Colors.white;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _menteeBackgroundColor,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/MLogoPink.png'),
                            fit: BoxFit.fill,
                          ),
                          border: Border.all(
                            color: _menteeBorderColor,
                            width: _menteeBorderWidth,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              offset: Offset(4, 3),
                              color: _menteeShadowColor,
                              spreadRadius: _menteeShadowBlur,
                            ),
                          ],
                        ),
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Mentee',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: kMentorXPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _enrollmentSelection = 'Mentor';
                        setState(() {
                          _nextButtonColor = kMentorXPrimary;
                          _errorTextColor = Colors.white;

                          _mentorBackgroundColor = kMentorXPrimary;
                          _mentorBorderWidth = 4.0;
                          _mentorBorderColor = Colors.greenAccent;
                          _mentorShadowBlur = 2.0;
                          _mentorShadowColor = Colors.grey;

                          _menteeBackgroundColor = Colors.grey;
                          _menteeBorderWidth = 0.0;
                          _menteeBorderColor = Colors.grey;
                          _menteeShadowBlur = 0.0;
                          _menteeShadowColor = Colors.white;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _mentorBackgroundColor,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/MLogoBlue.png'),
                            fit: BoxFit.scaleDown,
                          ),
                          border: Border.all(
                            color: _mentorBorderColor,
                            width: _mentorBorderWidth,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              offset: Offset(4, 3),
                              color: _mentorShadowColor,
                              spreadRadius: _mentorShadowBlur,
                            ),
                          ],
                        ),
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Mentor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: kMentorXPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 50.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                title: 'Next -->',
                buttonColor: _nextButtonColor,
                fontColor: Colors.white,
                minWidth: 250,
                onPressed: () async {
                  if (_enrollmentSelection == 'Mentor') {
                    await _confirmMentorEnrollment(context);
                  } else if (_enrollmentSelection == 'Mentee') {
                    await _confirmMenteeEnrollment(context);
                  } else {
                    setState(() {
                      _errorTextColor = Colors.red;
                    });
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please select Mentor or Mentee',
                style: TextStyle(
                  color: _errorTextColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
