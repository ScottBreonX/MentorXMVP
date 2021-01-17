import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/services/database.dart';

User loggedInUser;

class MyProfile extends StatefulWidget {
  const MyProfile({Key key, this.database, this.uid, this.fName})
      : super(key: key);

  static const String id = 'profile_screen';
  final Database database;
  final String uid;
  final String fName;

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  String fName;

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

  TextField _buildFirstNameTextField(BuildContext context) {
    return TextField(
      key: _formKey,
      controller: _firstNameController,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => fName = value,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(
        labelText: 'Enter your First name',
        labelStyle: TextStyle(color: Colors.black54),
        hintText: '${profileData['First Name']}',
        hintStyle: TextStyle(color: Colors.black54),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kMentorXTeal, width: 4.0),
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ),
        ),
      ),
    );
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

  Future<void> _createProfile(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: loggedInUser.uid);
      await database.createProfile(
        ProfileModel(
          email: loggedInUser.email,
          fName: fName,
          lName: profileData['Last Name'],
          major: profileData['Major'],
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
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
                  '${profileData['Major']}',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '2024',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _buildFirstNameTextField(context),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        offset: Offset(2, 3),
                        color: Colors.grey,
                        spreadRadius: 0.5,
                      )
                    ],
                  ),
                ),
              ],
            ),
            FloatingActionButton(
              onPressed: () {
                _createProfile(context);
                setState(() {
                  getProfileData();
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
