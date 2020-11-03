import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/login_screen.dart';
import 'package:mentorx_mvp/screens/registration_screen.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(MentorX());

class MentorX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
      },
    );
  }
}
