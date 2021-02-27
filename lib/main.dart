import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/screens/available_mentors_screen.dart';
import 'package:mentorx_mvp/screens/chat_screen.dart';
import 'package:mentorx_mvp/screens/edit_profile_screen.dart';
import 'package:mentorx_mvp/screens/landing_page.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/login_screen.dart';
import 'package:mentorx_mvp/screens/match_success_screen.dart';
import 'package:mentorx_mvp/screens/mentee_screen.dart';
import 'package:mentorx_mvp/screens/mentor_chat_screen.dart';
import 'package:mentorx_mvp/screens/mentor_screen.dart';
import 'package:mentorx_mvp/screens/profile_screen.dart';
import 'package:mentorx_mvp/screens/profile_test_screen.dart';
import 'package:mentorx_mvp/screens/registration_profile_screen.dart';
import 'package:mentorx_mvp/screens/view_profile_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'components/bottom_navigation_bar.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/mentoring_screen.dart';
import 'screens/events_screen.dart';
import 'services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MentorX());
}

class MentorX extends StatelessWidget {
  const MentorX({this.bloc});
  final LoginBloc bloc;

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
          RegistrationScreen.id: (context) => RegistrationScreen(
                bloc: bloc,
              ),
          RegistrationProfileScreen.id: (context) =>
              RegistrationProfileScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          MyProfile.id: (context) => MyProfile(),
          LaunchScreen.id: (context) => LaunchScreen(),
          EventsScreen.id: (context) => EventsScreen(),
          MentoringScreen.id: (context) => MentoringScreen(),
          MenteeScreen.id: (context) => MenteeScreen(),
          MentorScreen.id: (context) => MentorScreen(),
          AvailableMentors.id: (context) => AvailableMentors(),
          LandingPage.id: (context) => LandingPage(),
          EditMyProfile.id: (context) => EditMyProfile(),
          XBottomNavigationBar.id: (context) => XBottomNavigationBar(),
          ViewProfile.id: (context) => ViewProfile(),
          MatchSuccessScreen.id: (context) => MatchSuccessScreen(),
          MentorChatScreen.id: (context) => MentorChatScreen(),
          MyProfileTest.id: (context) => MyProfileTest(),
        },
      ),
    );
  }
}
