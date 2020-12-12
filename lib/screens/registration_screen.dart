import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  String email;
  String password;
  String passwordConfirm;

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
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (value) {
                    passwordConfirm = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Confirm Password'),
                ),
                SizedBox(height: 20.0),
                RoundedButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    if (password != passwordConfirm) {
                      setState(() {
                        showSpinner = false;
                      });
                      showAlertDialog(
                        context,
                        title: "Password Verification",
                        content: "Passwords do not match. Please try again.",
                        defaultActionText: "Ok",
                      );
                    } else {
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        if (newUser != null) {
                          Navigator.pushNamed(context, LaunchScreen.id);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } on FirebaseAuthException catch (e) {
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
                        } else if (e.code == 'email-already-in-use') {
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
                        showAlertDialog(
                          context,
                          title: "Invalid Registration",
                          content: "Please enter a valid email and password",
                          defaultActionText: "Ok",
                        );
                      }
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
