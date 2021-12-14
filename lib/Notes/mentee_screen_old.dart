//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:mentorx_mvp/components/rounded_button.dart';
//import 'package:mentorx_mvp/constants.dart';
//
//import 'available_mentors_old.dart';
//
//User tempUser;
//
//class MenteeScreenOld extends StatefulWidget {
//  static String id = 'mentee_screen_old';
//
//  @override
//  _MenteeScreenOldState createState() => _MenteeScreenOldState();
//}
//
//class _MenteeScreenOldState extends State<MenteeScreenOld> {
//  final _auth = FirebaseAuth.instance;
//
//  @override
//  void initState() {
//    getCurrentUser();
//    getProfileData();
//    super.initState();
//  }
//
//  void getCurrentUser() {
//    try {
//      final user = _auth.currentUser;
//      if (user != null) {
//        tempUser = user;
//      }
//    } catch (e) {
//      print(e);
//    }
//  }
//
//  dynamic profileData;
//
//  Future<dynamic> getProfileData() async {
//    await FirebaseFirestore.instance
//        .collection('users/${tempUser.uid}/profile')
//        .get()
//        .then((querySnapshot) {
//      querySnapshot.docs.forEach((result) {
//        setState(() {
//          profileData = result.data();
//        });
//      });
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        elevation: 5,
//        title: Text('Mentoring'),
//      ),
//      body: Container(
//        width: double.infinity,
//        height: double.infinity,
//        child: SingleChildScrollView(
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: [
//                RoundedButton(
//                  onPressed: () {
//                    Navigator.pushNamed(context, AvailableMentorsScreenOld.id);
//                  },
//                  minWidth: 500.0,
//                  title: 'View Available Mentors',
//                  buttonColor: kMentorXPrimary,
//                  fontColor: Colors.white,
//                ),
//                RoundedButton(
//                  onPressed: () {},
//                  minWidth: 500.0,
//                  title: 'Questionnaire',
//                  buttonColor: kMentorXPrimary,
//                  fontColor: Colors.white,
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
