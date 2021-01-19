import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/screens/profile_screen.dart';
import 'package:mentorx_mvp/services/database.dart';

User loggedInUser;

class EditMyProfile extends StatefulWidget {
  const EditMyProfile({
    Key key,
    this.database,
    this.uid,
  }) : super(key: key);

  static const String id = 'edit_profile_screen';
  final Database database;
  final String uid;

  @override
  _EditMyProfileState createState() => _EditMyProfileState();
}

class _EditMyProfileState extends State<EditMyProfile> {
  final _auth = FirebaseAuth.instance;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();

  String major;
  String fName;
  String lName;
  String yearInSchool;
  String hobbies;
  String motivations;
  String expertise;

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

  Future<void> _updateProfile(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: loggedInUser.uid);
      await database.updateProfile(
        ProfileModel(
          fName: profileData['First Name'],
          lName: profileData['Last Name'],
          email: loggedInUser.email,
          yearInSchool: yearInSchool,
          major: major,
          hobbies: hobbies,
          motivations: motivations,
          expertise: expertise,
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  TextFormField _buildFieldOfStudyTextField(BuildContext context) {
    return TextFormField(
      key: _formKey1,
      initialValue: major = profileData['Major'],
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => major = value,
      style: TextStyle(
        color: kMentorXTeal,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: '',
        hintText: '',
      ),
    );
  }

  TextFormField _buildYearInSchoolTextField(BuildContext context) {
    return TextFormField(
      key: _formKey2,
      initialValue: yearInSchool = profileData['Year in School'],
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => yearInSchool = value,
      style: TextStyle(
        color: kMentorXTeal,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: '',
        hintText: '',
      ),
    );
  }

  TextFormField _buildHobbiesTextField(BuildContext context) {
    return TextFormField(
      key: _formKey3,
      initialValue: hobbies = profileData['Hobbies'],
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => hobbies = value,
      style: TextStyle(
        color: kMentorXTeal,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: '',
        hintText: '',
      ),
    );
  }

  TextFormField _buildMotivationsTextField(BuildContext context) {
    return TextFormField(
      key: _formKey4,
      initialValue: motivations = profileData['Motivations'],
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => motivations = value,
      style: TextStyle(
        color: kMentorXTeal,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: '',
        hintText: '',
      ),
    );
  }

  TextFormField _buildExpertiseTextField(BuildContext context) {
    return TextFormField(
      key: _formKey5,
      initialValue: expertise = profileData['Expertise'],
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => expertise = value,
      style: TextStyle(
        color: kMentorXTeal,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: '',
        hintText: '',
      ),
    );
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
        title: Text('Edit Profile'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0),
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
                Flexible(
                  child: Text(
                    '${profileData['Year in School']},',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black54,
                    ),
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
              height: 20,
            ),
            const Divider(
              color: kMentorXTeal,
              height: 20,
              thickness: 4,
              indent: 0,
              endIndent: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _updateProfile(context);
                    });
                    Navigator.popAndPushNamed(context, MyProfile.id);
                  },
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
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
                      Icons.save,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _buildFieldOfStudyTextField(context),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'Year in School',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildYearInSchoolTextField(context),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'Hobbies',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildHobbiesTextField(context),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'Motivations',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildMotivationsTextField(context),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'Expertise',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildExpertiseTextField(context),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
