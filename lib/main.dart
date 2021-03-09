import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/screens/enrollment/available_mentors_screen.dart';
import 'package:mentorx_mvp/screens/enrollment/enrollment_start_screen.dart';
import 'package:mentorx_mvp/screens/enrollment/enrollment_selection_screen.dart';
import 'package:mentorx_mvp/screens/landing_page.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/login/login_screen.dart';
import 'package:mentorx_mvp/screens/enrollment/mentee_screen.dart';
import 'package:mentorx_mvp/screens/chat/mentor_chat_screen.dart';
import 'package:mentorx_mvp/screens/enrollment/mentor_screen.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/screens/registration/registration_profile_screen.dart';
import 'package:mentorx_mvp/screens/enrollment/view_profile_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'bottom_navigation_bar.dart';
import 'screens/login/welcome_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/registration/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/mentoring/mentoring_screen.dart';
import 'screens/events/events_screen.dart';
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
          MyProfile.id: (context) => MyProfile(),
          LaunchScreen.id: (context) => LaunchScreen(),
          EventsScreen.id: (context) => EventsScreen(),
          MentoringScreen.id: (context) => MentoringScreen(),
          MenteeScreen.id: (context) => MenteeScreen(),
          MentorScreen.id: (context) => MentorScreen(),
          AvailableMentors.id: (context) => AvailableMentors(),
          LandingPage.id: (context) => LandingPage(),
          XBottomNavigationBar.id: (context) => XBottomNavigationBar(
                pageIndex: 0,
              ),
          ViewProfile.id: (context) => ViewProfile(),
          MentorChatScreen.id: (context) => MentorChatScreen(),
          EnrollmentStartScreen.id: (context) => EnrollmentStartScreen(),
          EnrollmentSelectionScreen.id: (context) =>
              EnrollmentSelectionScreen(),
        },
      ),
    );
  }
}
