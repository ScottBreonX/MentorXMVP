import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/services/database.dart';

User loggedInUser;

class MyProfile extends StatefulWidget {
  const MyProfile({
    Key key,
    this.database,
    this.uid,
  }) : super(key: key);

  static const String id = 'profile_screen';
  final Database database;
  final String uid;

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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

//  Future<void> _createProfile(BuildContext context) async {
//    try {
//      final database = FirestoreDatabase(uid: loggedInUser.uid);
//      await database.createProfile(
//        ProfileModel(
//          email: loggedInUser.email,
//          fName: fName,
//          lName: profileData['Last Name'],
//          major: profileData['Major'],
//        ),
//      );
//    } on FirebaseException catch (e) {
//      showAlertDialog(context,
//          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
//    }
//  }

  @override
  Widget build(BuildContext context) {
    if (profileData == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: kMentorXTeal,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXTeal,
        title: Text('My Profile'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16.0, top: 45.0, right: 16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          offset: Offset(2, 3),
                          color: Colors.grey,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: kMentorXTeal,
                      radius: 80,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 75,
                        child: Icon(
                          Icons.person,
                          color: kMentorXTeal,
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kMentorXTeal,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            offset: Offset(2, 3),
                            color: Colors.grey,
                            spreadRadius: 0.5,
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${profileData['First Name']}',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '${profileData['Last Name']}',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${profileData['Year in school']},',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '${profileData['Major']}',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Text(
                  'Field of Study: ',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${profileData['Major']}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: kMentorXTeal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Text(
                  'Year in school: ',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${profileData['Year in school']}',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: kMentorXTeal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Text(
                  'Hobbies: ',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${profileData['Hobbies']}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: kMentorXTeal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Text(
                  'Motivations: ',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${profileData['Motivations']}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: kMentorXTeal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Text(
                  'Expertise: ',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${profileData['Expertise']}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: kMentorXTeal,
                      fontWeight: FontWeight.w500,
                    ),
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
