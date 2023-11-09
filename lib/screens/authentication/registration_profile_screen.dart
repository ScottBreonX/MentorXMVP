import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  bool showSpinner = false;

  Future<void> _createProfile(BuildContext context) async {
    try {
      final database = FirestoreDatabase();
      await database.createProfile(
        myUser(
          id: user.uid,
          email: user.email,
          firstName: firstName,
          lastName: lastName,
          aboutMe: aboutMe ?? '',
          workExperience: workExperience ?? '',
          program: '',
          profilePicture: '',
          coverPhoto: '',
          canCreateProgram: false,
          welcomeMessage: true,
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
      textAlign: TextAlign.start,
      onChanged: (value) {
        firstName = value;
        setState(() {});
      },
      style: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        prefixIcon: Icon(
          Icons.person,
          color: kMentorXPAccentMed,
        ),
        labelText: 'First Name',
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kMentorXPAccentMed, width: 4.0),
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
      textAlign: TextAlign.start,
      onChanged: (value) {
        lastName = value;
        setState(() {});
      },
      style: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        prefixIcon: Icon(
          Icons.person,
          color: kMentorXPAccentMed,
        ),
        labelText: 'Last Name',
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kMentorXPAccentMed, width: 4.0),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user.uid == null) {
      return circularProgress(Theme.of(context).primaryColor);
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: Container(),
        backgroundColor: Colors.transparent,
        // title: Text(
        //   'Create Profile',
        //   style: Theme.of(context)
        //       .textTheme
        //       .headlineLarge
        //       .copyWith(color: Colors.white),
        // ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 100),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.grey.shade600,
              kMentorXPPrimary,
            ],
          ),
        ),
        child: showSpinner
            ? circularProgress(Colors.white.withOpacity(1))
            : SingleChildScrollView(
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
                          height: 80.0,
                          child: Image.asset('assets/images/MentorXP.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 50.0, bottom: 20, left: 20, right: 20),
                        child: Text(
                          'Enter your first and last name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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
                        onPressed: (_firstNameController.value.text.isEmpty ||
                                _lastNameController.value.text.isEmpty)
                            ? () {}
                            : () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                await _createProfile(context).then((_) {
                                  Navigator.popAndPushNamed(
                                      context, VerifyEmailScreen.id);
                                });
                                setState(() {
                                  showSpinner = false;
                                });
                              },
                        title: 'Submit',
                        buttonColor: (_firstNameController.value.text.isEmpty ||
                                _lastNameController.value.text.isEmpty)
                            ? Colors.grey
                            : kMentorXPAccentDark,
                        fontColor: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
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
