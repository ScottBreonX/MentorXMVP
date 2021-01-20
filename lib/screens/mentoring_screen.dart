import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/mentee_model.dart';
import 'package:mentorx_mvp/services/database.dart';

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
    getProfileData();
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

  Future<void> _updateMenteeEnrollment(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: loggedInUser.uid);
      await database.createMentee(
        MenteeModel(
          fName: profileData['First Name'],
          lName: profileData['Last Name'],
          yearInSchool: profileData['Year in School'],
          major: profileData['Major'],
          uid: loggedInUser.uid,
          status: 'Available',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  onPressed: () => _updateMenteeEnrollment(context),
                  minWidth: 500.0,
                  title: 'Enroll as Mentee',
                  buttonColor: kMentorXTeal,
                  fontColor: Colors.white,
                ),
                RoundedButton(
                  onPressed: () => print(
                      '${profileData["First Name"]} ${profileData["Last Name"]} enrolled as a mentor'),
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
  }
}
