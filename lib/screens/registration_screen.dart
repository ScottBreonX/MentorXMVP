import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({@required this.auth});
  static const String id = 'registration_screen';
  final AuthBase auth;

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool showSpinner = false;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  String get _passwordConfirm => _passwordConfirmController.text;

  void _submit() async {
    setState(() {
      showSpinner = true;
    });
    try {
      await widget.auth.createUserWithEmailAndPassword(_email, _password);
      Navigator.of(context).popAndPushNamed(LaunchScreen.id);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'invalid-email') {
        setState(() {
          showSpinner = false;
        });
        showAlertDialog(
          context,
          title: "Invalid Email",
          content: "Please enter a valid email address",
          defaultActionText: "Ok",
        );
      }
      if (e.code == 'email-already-in-use') {
        setState(() {
          showSpinner = false;
        });
        showAlertDialog(
          context,
          title: "Email already in use",
          content:
              "Email is already in use. Try new email or proceed to log in.",
          defaultActionText: "Ok",
        );
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print(e.toString());
      showAlertDialog(
        context,
        title: "Invalid Registration",
        content: "Please enter a valid email and password",
        defaultActionText: "Ok",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXTeal,
        title: Text('Create Account'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
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
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Enter your email'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Enter your password'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: _passwordConfirmController,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Confirm Password'),
                ),
                SizedBox(height: 20.0),
                RoundedButton(
                  onPressed: () {
                    if (_password != _passwordConfirm) {
                      showAlertDialog(
                        context,
                        title: "Confirm Password",
                        content:
                            "Passwords do not match. Please re-enter password.",
                        defaultActionText: "Ok",
                      );
                    } else {
                      _submit();
                    }
                  },
                  title: 'REGISTER',
                  color: kMentorXTeal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
