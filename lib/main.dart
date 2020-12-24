import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/chat_screen.dart';
import 'package:mentorx_mvp/screens/landing_page.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/profile_screen.dart';
import 'screens/mentoring_screen.dart';
import 'screens/events_screen.dart';
import 'services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MentorX());
}

class MentorX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LandingPage.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(
              auth: Auth(),
            ),
        LoginScreen.id: (context) => LoginScreen(
              auth: Auth(),
            ),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        LaunchScreen.id: (context) => LaunchScreen(
              auth: Auth(),
            ),
        MyProfile.id: (context) => MyProfile(),
        EventsScreen.id: (context) => EventsScreen(),
        MentoringScreen.id: (context) => MentoringScreen(),
        LandingPage.id: (context) => LandingPage(auth: Auth()),
      },
    );
  }
}
