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
                const Duration(seconds: 2),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Scaffold(
                    backgroundColor: kMentorXPPrimary,
                    body: Container(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Container(
                              child: Image.asset(
                                'assets/images/MentorXP.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text(
                            'Connecting the world',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kMentorXPAccentMed,
                              fontFamily: 'RockSalt',
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'in a more meaningful way',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'RockSalt',
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
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
