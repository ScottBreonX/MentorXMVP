import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/bottom_navigation_bar.dart';
import 'package:mentorx_mvp/constants.dart';

User loggedInUser;

class MatchSuccessScreen extends StatefulWidget {
  const MatchSuccessScreen({Key key, this.mentorUID}) : super(key: key);

  static String id = 'match_success_screen';
  final String mentorUID;

  @override
  _MatchSuccessScreenState createState() => _MatchSuccessScreenState();
}

class _MatchSuccessScreenState extends State<MatchSuccessScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
    getProfileData();
    getMentorProfileData();
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
        .collection('users/${widget.mentorUID}/profile')
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
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.popAndPushNamed(context, XBottomNavigationBar.id);
            },
          ),
        ],
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
                Text(
                    'Mentor: ${mentorProfileData['First Name']} ${mentorProfileData['Last Name']}'),
                Text(
                    'Mentee: ${profileData['First Name']} ${profileData['Last Name']}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
