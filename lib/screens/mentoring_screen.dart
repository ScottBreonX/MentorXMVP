import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/mentoring_model.dart';
import 'package:mentorx_mvp/screens/mentee_screen.dart';
import 'package:mentorx_mvp/screens/mentor_screen.dart';
import 'package:mentorx_mvp/services/database.dart';
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
    final didEnroll = await showAlertDialog(
      context,
      title: "Mentor Enrollment",
      content: "Confirm enrollment as a mentor?",
      defaultActionText: "Yes",
      cancelActionText: "Go back",
    );
    if (didEnroll == true) {
      _createMentor(context)
          .then((value) => Navigator.pushNamed(context, MentorScreen.id));
    }
  }

  Future<void> _confirmMenteeEnrollment(BuildContext context) async {
    final didEnroll = await showAlertDialog(
      context,
      title: "Mentee Enrollment",
      content: "Confirm enrollment as a mentee?",
      defaultActionText: "Yes",
      cancelActionText: "Go back",
    );
    if (didEnroll == true) {
      _createMentee(context)
          .then((value) => Navigator.pushNamed(context, MenteeScreen.id));
    }
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
                            _nextButtonColor = kMentorXTeal;
                            _errorTextColor = Colors.white;

                            _menteeBackgroundColor = kMentorXTeal;
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
                              image: AssetImage('images/XLogoWhite.png'),
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
                        color: kMentorXTeal,
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
                            _nextButtonColor = kMentorXTeal;
                            _errorTextColor = Colors.white;

                            _mentorBackgroundColor = kMentorXTeal;
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
                              image: AssetImage('images/XLogoWhite.png'),
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
                        color: kMentorXTeal,
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
