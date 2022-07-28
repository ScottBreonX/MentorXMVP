import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            title: Text('Verify Email'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A verification email has been sent to your email address. You must verify your email address before continuing.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'If you don\'nt see the email in your inbox please check your Spam folder. The email will be sent from MentorX.',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                    ),
                    icon: Icon(Icons.email, size: 32),
                    label: Text(
                      'Resend Email',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: canResendEmail ? sendVerificationEmail : null),
                SizedBox(height: 8),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.popAndPushNamed(context, LandingPage.id);
                  },
                )
              ],
            ),
          ),
        );
}
