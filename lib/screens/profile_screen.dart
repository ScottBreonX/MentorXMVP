import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User loggedInUser;
final _firestore = FirebaseFirestore.instance;

class MyProfile extends StatefulWidget {
  static const String id = 'profile_screen';

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXTeal,
        title: Text('My Profile'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              '$loggedInUser',
            ),
          ],
        ),
      ),
    );
  }
}
