import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/screens/authentication/landing_page.dart';
import 'package:mentorx_mvp/screens/authentication/login_screen.dart';
import 'package:mentorx_mvp/screens/authentication/welcome_screen.dart';
import 'package:mentorx_mvp/screens/chat/chat_screen.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/available_mentors.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_lauch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/screens/notifications/notifications_screen.dart';
import 'package:mentorx_mvp/screens/authentication/registration_profile_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_selection_screen.dart';
import 'package:mentorx_mvp/screens/selection_screen/selection_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'Notes/available_mentors_old.dart';
import 'Notes/mentee_screen_old.dart';
import 'Notes/mentor_screen_old.dart';
import 'Notes/mentoring_screen_old.dart';
import 'screens/authentication/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
//          colorScheme: ColorScheme.fromSwatch().copyWith(
//            secondary: Colors.pink,
//          ),
        ),

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
          EventsScreen.id: (context) => EventsScreen(),
          MyProfile.id: (context) => MyProfile(),
          MentorLaunch.id: (context) => MentorLaunch(),
          LandingPage.id: (context) => LandingPage(),
          SelectionScreen.id: (context) => SelectionScreen(),
          NotificationScreen.id: (context) => NotificationScreen(),
          MentoringScreen.id: (context) => MentoringScreen(),
          MentoringScreenOld.id: (context) => MentoringScreenOld(),
          MentorScreenOld.id: (context) => MentorScreenOld(),
          MenteeScreenOld.id: (context) => MenteeScreenOld(),
          AvailableMentorsScreenOld.id: (context) =>
              AvailableMentorsScreenOld(),
          AvailableMentorsScreen.id: (context) => AvailableMentorsScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          ProgramSelectionScreen.id: (context) => ProgramSelectionScreen(),
        },
      ),
    );
  }
}
