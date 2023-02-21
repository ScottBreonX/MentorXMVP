import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/authentication/welcome_screen.dart';
import 'package:mentorx_mvp/screens/home_screen/home_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';

import '../../components/progress.dart';
import '../../models/user.dart';

myUser loggedInUser;
final usersRef = FirebaseFirestore.instance.collection('users');

class LandingPage extends StatefulWidget {
  static const String id = 'landing_page';

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;

          if (user == null) {
            return FutureBuilder(
              future: Future.delayed(
                const Duration(seconds: 3),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Scaffold(
                    backgroundColor: kMentorXPPrimary,
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/MentorXP.png',
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  );
                }
                return WelcomeScreen.create(context);
              },
            );
          }

          return FutureBuilder<DocumentSnapshot>(
              future: usersRef.doc(user.uid).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }
                myUser _user = myUser.fromDocument(snapshot.data);

                if (_user.program == "") {
                  return HomeScreen(
                    loggedInUser: _user,
                  );
                }

                return ProgramLaunchScreen(
                  programUID: _user.program,
                  loggedInUser: _user,
                );
              });
        }
        return Scaffold(
          backgroundColor: kMentorXPPrimary,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
