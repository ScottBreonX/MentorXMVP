import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/menu_bar.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';

User loggedInUser;

class EnrollmentScreen extends StatefulWidget {
  static String id = 'enrollment_screen';

  @override
  _EnrollmentScreenState createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
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
          backgroundColor: kMentorXTeal,
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
          color: kDrawerItems,
        ),
      ),
      appBar: AppBar(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                title: 'Next -->',
                buttonColor: kMentorXTeal,
                fontColor: Colors.white,
                minWidth: 250,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
