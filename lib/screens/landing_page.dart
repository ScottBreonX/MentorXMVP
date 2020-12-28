import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/welcome_screen.dart';
import 'package:mentorx_mvp/services/auth_provider.dart';

class LandingPage extends StatelessWidget {
  static const String id = 'landing_page';

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          try {
            if (user == null) {
              return WelcomeScreen();
            }
            return LaunchScreen();
          } catch (e) {
            return WelcomeScreen();
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
