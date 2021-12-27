import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentorx_mvp/components/apptheme.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/screens/authentication/landing_page.dart';
import 'package:mentorx_mvp/screens/authentication/login_screen.dart';
import 'package:mentorx_mvp/screens/authentication/welcome_screen.dart';
import 'package:mentorx_mvp/screens/chat/chat_screen.dart';
import 'package:mentorx_mvp/screens/home_screen/home_screen.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/available_mentors.dart';
import 'package:mentorx_mvp/screens/mentoring/available_programs.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_launch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/screens/notifications/notifications_screen.dart';
import 'package:mentorx_mvp/screens/authentication/registration_profile_screen.dart';
import 'package:mentorx_mvp/screens/profile/sections/edit_profile_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_join_request.dart';
import 'package:mentorx_mvp/screens/programs/program_profile.dart';
import 'package:mentorx_mvp/screens/programs/program_selection_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'screens/authentication/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
// Navigator routes
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
          LaunchScreen.id: (context) => LaunchScreen(),
          Profile.id: (context) => Profile(),
          MentorLaunch.id: (context) => MentorLaunch(),
          LandingPage.id: (context) => LandingPage(),
          HomeScreen.id: (context) => HomeScreen(),
          NotificationScreen.id: (context) => NotificationScreen(),
          MentoringScreen.id: (context) => MentoringScreen(),
          AvailableMentorsScreen.id: (context) => AvailableMentorsScreen(),
          AvailableProgramsScreen.id: (context) => AvailableProgramsScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          ProgramSelectionScreen.id: (context) => ProgramSelectionScreen(),
          ProgramProfile.id: (context) => ProgramProfile(),
          ProgramJoinRequest.id: (context) => ProgramJoinRequest(),
          EditProfileScreen.id: (context) => EditProfileScreen(),
        },
      ),
    );
  }
}
