import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
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

  String fName;
  String lName;

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
      onChanged: (value) => fName = value,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: 'Enter your first name',
        fillColor: Colors.white.withOpacity(0.05),
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
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: 'Enter your last name',
        fillColor: Colors.white.withOpacity(0.05),
        filled: true,
//        errorText: model.emailErrorText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;
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
                RoundedButton(
                  onPressed: () async {
                    await _createProfile(context);
                    Navigator.pushNamed(context, HomeScreen.id);
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
