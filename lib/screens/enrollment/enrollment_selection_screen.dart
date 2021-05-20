import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/custom_dialog.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/mentoring_model.dart';
import 'package:mentorx_mvp/screens/enrollment/mentee_screen.dart';
import 'package:mentorx_mvp/screens/enrollment/mentor_screen.dart';
import 'package:mentorx_mvp/services/database.dart';

User loggedInUser;

class EnrollmentSelectionScreen extends StatefulWidget {
  static String id = 'enrollment_selection_screen';

  @override
  _EnrollmentSelectionScreenState createState() =>
      _EnrollmentSelectionScreenState();
}

class _EnrollmentSelectionScreenState extends State<EnrollmentSelectionScreen> {
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

  Color _mentorBackgroundColor = Colors.white.withOpacity(0.10);
  Color _mentorBorderColor = kMentorXBlack;
  double _mentorBorderWidth = 0;

  Color _menteeBackgroundColor = Colors.white.withOpacity(0.10);
  Color _menteeBorderColor = kMentorXBlack;
  double _menteeBorderWidth = 0;

  Color _nextButtonColor = Colors.grey;
  String _enrollmentSelection = 'Nothing';
  Color _errorTextColor = kMentorXBlack.withOpacity(0);

  Future<void> _confirmMentorEnrollment(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              title: 'Mentor Enrollment',
              titleFontSize: 20.0,
              descriptions: 'Confirm enrollment as mentor?',
              descriptionFontSize: 20.0,
              textLeft: 'Yes',
              textRight: 'No',
              rightOnPressed: () {
                Navigator.pop(context);
              },
              leftOnPressed: () {
                _createMentor(context).then(
                    (value) => Navigator.pushNamed(context, MentorScreen.id));
              });
        });
  }

  Future<void> _confirmMenteeEnrollment(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              title: 'Mentee Enrollment',
              titleFontSize: 20.0,
              descriptions: 'Confirm enrollment as mentee?',
              descriptionFontSize: 20.0,
              textLeft: 'Yes',
              textRight: 'No',
              rightOnPressed: () {
                Navigator.pop(context);
              },
              leftOnPressed: () {
                _createMentee(context).then(
                    (value) => Navigator.pushNamed(context, MenteeScreen.id));
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXDark.withOpacity(0.95),
        title: Text('Mentoring'),
      ),
      body: Container(
        decoration: BoxDecoration(color: kMentorXDark),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: Center(
                      child: Text(
                        'Select your enrollment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
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
                            _errorTextColor = kMentorXDark.withOpacity(0);

                            _menteeBackgroundColor = kMentorXPrimary;
                            _menteeBorderWidth = 4.0;
                            _menteeBorderColor = kMentorXPrimary;

                            _mentorBackgroundColor =
                                Colors.white.withOpacity(0.10);
                            _mentorBorderWidth = 0.0;
                            _mentorBorderColor = kMentorXBlack;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: _menteeBackgroundColor,
                            border: Border.all(
                              color: _menteeBorderColor,
                              width: _menteeBorderWidth,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                offset: Offset(4, 3),
                              ),
                            ],
                          ),
                          child: Center(
                              child: FaIcon(
                            FontAwesomeIcons.userGraduate,
                            color: Colors.white,
                            size: 75,
                          )),
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
                        color: Colors.white,
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
                            _errorTextColor = kMentorXDark.withOpacity(0);

                            _mentorBackgroundColor = kMentorXPrimary;
                            _mentorBorderWidth = 4.0;
                            _mentorBorderColor = kMentorXPrimary;

                            _menteeBackgroundColor =
                                Colors.white.withOpacity(0.10);
                            _menteeBorderWidth = 0.0;
                            _menteeBorderColor = kMentorXBlack;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: _mentorBackgroundColor,
                            border: Border.all(
                              color: _mentorBorderColor,
                              width: _mentorBorderWidth,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                offset: Offset(4, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.chalkboardTeacher,
                              color: Colors.white,
                              size: 75,
                            ),
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
                        color: Colors.white,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RoundedButton(
                  title: 'Next',
                  fontSize: 20.0,
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
                        _errorTextColor = Colors.white;
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
      ),
    );
  }
}
