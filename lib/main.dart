import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/screens/chat_screen.dart';
import 'package:mentorx_mvp/screens/landing_page.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/login_screen_blocbased.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen_blocbased.dart';
import 'screens/registration_screen_blocbased.dart';
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
  const MentorX({this.bloc, this.database});
  final LoginBloc bloc;
  final Database database;

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: LandingPage.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(
                bloc: bloc,
              ),
          LoginScreenBlocBased.id: (context) => LoginScreenBlocBased(
                bloc: bloc,
              ),
          RegistrationScreenBlocBased.id: (context) =>
              RegistrationScreenBlocBased(
                bloc: bloc,
              ),
          ChatScreen.id: (context) => ChatScreen(),
          LaunchScreen.id: (context) => LaunchScreen(),
          MyProfile.id: (context) => MyProfile(
                database: database,
              ),
          EventsScreen.id: (context) => EventsScreen(),
          MentoringScreen.id: (context) => MentoringScreen(),
          LandingPage.id: (context) => LandingPage(),
        },
      ),
    );
  }
}
