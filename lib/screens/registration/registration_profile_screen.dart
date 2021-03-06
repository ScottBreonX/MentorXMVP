import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/bottom_navigation_bar.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/services/database.dart';

User loggedInUser;

class RegistrationProfileScreen extends StatefulWidget {
  static const String id = 'registration_profile_screen';
  @override
  _RegistrationProfileScreenState createState() =>
      _RegistrationProfileScreenState();
}

class _RegistrationProfileScreenState extends State<RegistrationProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  String fName;
  String lName;
  String major;
  String yearInSchool;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _fieldOfStudyController = TextEditingController();
  final TextEditingController _yearInSchoolController = TextEditingController();

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

  Future<void> _createProfile(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: loggedInUser.uid);
      await database.createProfile(
        ProfileModel(
          email: loggedInUser.email,
          fName: fName,
          lName: lName,
          major: major,
          yearInSchool: yearInSchool,
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
          print(profileData);
        });
      });
    });
  }

  TextField _buildFirstNameTextField(BuildContext context) {
    return TextField(
      key: _formKey,
      controller: _firstNameController,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => fName = value,
      style: TextStyle(
        color: kMentorXPrimary,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: 'Enter your first name',
        fillColor: Colors.white70,
        filled: true,
//        errorText: model.emailErrorText,
      ),
    );
  }

  TextField _buildLastNameTextField(BuildContext context) {
    return TextField(
      key: _formKey2,
      controller: _lastNameController,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => lName = value,
      style: TextStyle(
        color: kMentorXPrimary,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: 'Enter your last name',
        fillColor: Colors.white70,
        filled: true,
//        errorText: model.emailErrorText,
      ),
    );
  }

  TextField _buildFieldOfStudyTextField(BuildContext context) {
    return TextField(
      key: _formKey3,
      controller: _fieldOfStudyController,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => major = value,
      style: TextStyle(
        color: kMentorXPrimary,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: 'Enter your field of study',
        hintText: 'i.e. Economics',
        fillColor: Colors.white70,
        filled: true,
//        errorText: model.emailErrorText,
      ),
    );
  }

  TextField _buildYearInSchoolTextField(BuildContext context) {
    return TextField(
      key: _formKey4,
      controller: _yearInSchoolController,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => yearInSchool = value,
      style: TextStyle(
        color: kMentorXPrimary,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: 'Year in School',
        hintText: 'i.e. Junior',
        filled: true,
        fillColor: Colors.white70,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXPrimary,
        title: Text('Create Profile'),
        centerTitle: true,
      ),
//            backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: kMentorXDark,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50,
                ),
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 150.0,
                    child: Image.asset('images/XLogo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                _buildFirstNameTextField(context),
                SizedBox(
                  height: 20,
                ),
                _buildLastNameTextField(context),
                SizedBox(
                  height: 20.0,
                ),
                _buildFieldOfStudyTextField(context),
                SizedBox(height: 20.0),
                _buildYearInSchoolTextField(context),
                SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  onPressed: () async {
                    await _createProfile(context);
                    Navigator.pushNamed(context, XBottomNavigationBar.id);
                  },
                  title: 'Submit',
                  buttonColor: kMentorXPrimary,
                  fontColor: Colors.white,
                  minWidth: 500.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
