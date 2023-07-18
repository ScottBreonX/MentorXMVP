import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/authentication/landing_page.dart';

class VerifyEmailScreen extends StatefulWidget {
  static const String id = 'verify_email_screen';
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer timer;

  @override
  void initState() {
    super.initState();

    // check if the email has been verified
    isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    });

    if (isEmailVerified) timer.cancel();
  }

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    await user.sendEmailVerification();

    setState(() => canResendEmail = false);
    await Future.delayed(Duration(seconds: 5));
    setState(() => canResendEmail = true);
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? LandingPage()
      : Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              child: Icon(Icons.close),
              onTap: () {
                Navigator.popAndPushNamed(context, LandingPage.id);
              },
            ),
            backgroundColor: kMentorXPPrimary,
            title: Text(
              'Verify Email',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 100, left: 40, right: 40),
            child: Column(
              children: [
                Text(
                  'Verification email sent to your email address.',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: kMentorXPPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Please verify your email address before continuing.',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Montserrat',
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                RoundedButton(
                  title: 'Resend Email',
                  buttonColor: kMentorXPSecondary,
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  textAlignment: MainAxisAlignment.center,
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                Text(
                  'If you don\'nt see an email in your inbox please check your Spam folder. The email will be sent from The MentorUP Team.',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w100,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
}
