import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/authentication/verify_email_screen.dart';
import 'package:mentorx_mvp/services/database.dart';

import '../../components/progress.dart';

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
  User user;

  String firstName;
  String lastName;
  String major;
  String yearInSchool;
  int mentorSlots;
  String aboutMe;
  String workExperience;
  String mentorAbout;
  String menteeAbout;
  bool mentor;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        this.user = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _createProfile(BuildContext context) async {
    try {
      final database = FirestoreDatabase();
      await database.createProfile(
        myUser(
          id: user.uid,
          email: user.email,
          firstName: firstName,
          lastName: lastName,
          major: major ?? '',
          yearInSchool: yearInSchool ?? '',
          aboutMe: aboutMe ?? '',
          workExperience: workExperience ?? '',
          mentorAbout: mentorAbout ?? '',
          menteeAbout: menteeAbout ?? '',
          profilePicture: '',
          coverPhoto: '',
          canCreateProgram: false,
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  TextField _buildFirstNameTextField(BuildContext context) {
    return TextField(
      key: _formKey,
      controller: _firstNameController,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => firstName = value,
      style: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        prefixIcon: Icon(Icons.person),
        labelText: 'First Name',
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 4.0),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
    );
  }

  TextField _buildLastNameTextField(BuildContext context) {
    return TextField(
      key: _formKey2,
      controller: _lastNameController,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) => lastName = value,
      style: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        prefixIcon: Icon(Icons.person),
        labelText: 'Last Name',
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 4.0),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;

    if (user.uid == null) {
      return circularProgress();
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Create Profile'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 100),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue,
              Colors.pink,
            ],
          ),
        ),
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
                    child: Image.asset('assets/images/MLogoWhite.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Enter your first and last name',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildFirstNameTextField(context),
                SizedBox(
                  height: 20,
                ),
                _buildLastNameTextField(context),
                SizedBox(
                  height: 20.0,
                ),
                RoundedButton(
                  textAlignment: MainAxisAlignment.center,
                  onPressed: () async {
                    await _createProfile(context).then((_) {
                      Navigator.popAndPushNamed(context, VerifyEmailScreen.id);
                    });
                  },
                  title: 'Submit',
                  buttonColor: kMentorXPrimary,
                  fontColor: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
