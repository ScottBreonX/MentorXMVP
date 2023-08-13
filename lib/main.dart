import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentorx_mvp/components/apptheme.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/screens/authentication/landing_page.dart';
import 'package:mentorx_mvp/screens/authentication/login_screen.dart';
import 'package:mentorx_mvp/screens/authentication/reset_password_screen.dart';
import 'package:mentorx_mvp/screens/authentication/verify_email_screen.dart';
import 'package:mentorx_mvp/screens/authentication/welcome_screen.dart';
import 'package:mentorx_mvp/screens/home_screen/home_screen.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/available_mentors.dart';
import 'package:mentorx_mvp/screens/program_creation/program_creation.dart';
import 'package:mentorx_mvp/screens/programs/available_programs.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_confirmation.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_admin/program_admin_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_enrollment_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/screens/authentication/registration_profile_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_join_request.dart';
import 'package:mentorx_mvp/screens/programs/program_profile.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'screens/authentication/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
myUser loggedInUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MentorX());
  // print('Token:' + await FirebaseMessaging.instance.getToken());
}

// class ThemeProvider extends ChangeNotifier {
//   ThemeMode themeMode = ThemeMode.light;
//
//   void toggleTheme() {
//     themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
// }

// Future _checkForTheme(myUser loggedInUser) {
//   if (loggedInUser != null) {
//     print(loggedInUser.id);
//   } else {
//     // The user is signed out
//     print('not logged in');
//   }
// }

class MentorX extends StatefulWidget {
  const MentorX({this.bloc});
  final LoginBloc bloc;

  @override
  State<MentorX> createState() => _MentorXState();
  static _MentorXState of(BuildContext context) =>
      context.findAncestorStateOfType<_MentorXState>();
}

class _MentorXState extends State<MentorX> {
  ThemeData _themeMode = AppTheme.lightTheme;

  void changeTheme(ThemeData themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

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
        // theme: loggedInUser.darkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        theme: _themeMode,
        // themeMode: _themeMode,
// Navigator routes
        initialRoute: LandingPage.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(
                bloc: widget.bloc,
              ),
          LoginScreenBlocBased.id: (context) => LoginScreenBlocBased(
                bloc: widget.bloc,
              ),
          RegistrationScreen.id: (context) => RegistrationScreen(
                bloc: widget.bloc,
              ),
          RegistrationProfileScreen.id: (context) =>
              RegistrationProfileScreen(),
          VerifyEmailScreen.id: (context) => VerifyEmailScreen(),
          LaunchScreen.id: (context) => LaunchScreen(),
          Profile.id: (context) => Profile(),
          LandingPage.id: (context) => LandingPage(),
          HomeScreen.id: (context) => HomeScreen(),
          MentoringScreen.id: (context) => MentoringScreen(),
          AvailableMentorsScreen.id: (context) => AvailableMentorsScreen(),
          AvailableProgramsScreen.id: (context) => AvailableProgramsScreen(),
          ProgramProfile.id: (context) => ProgramProfile(),
          ProgramJoinRequest.id: (context) => ProgramJoinRequest(),
          ProgramLaunchScreen.id: (context) => ProgramLaunchScreen(),
          ProgramEnrollmentScreen.id: (context) => ProgramEnrollmentScreen(),
          MentorConfirm.id: (context) => MentorConfirm(),
          ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
          ProgramCreation.id: (context) => ProgramCreation(),
          ProgramAdminScreen.id: (context) => ProgramAdminScreen(),
        },
      ),
    );
  }
}
