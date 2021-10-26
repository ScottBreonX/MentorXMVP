import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/screens/authentication/landing_page.dart';
import 'package:mentorx_mvp/screens/authentication/login_screen.dart';
import 'package:mentorx_mvp/screens/authentication/welcome_screen.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:mentorx_mvp/screens/enrollment/mentor_screen.dart';
import 'package:mentorx_mvp/screens/news_feed/news_feed.dart';
import 'package:mentorx_mvp/screens/notifications/notifications_screen.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/screens/authentication/registration_profile_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
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
          MentorScreen.id: (context) => MentorScreen(),
          LandingPage.id: (context) => LandingPage(),
          NewsFeed.id: (context) => NewsFeed(),
          NotificationScreen.id: (context) => NotificationScreen(),
        },
      ),
    );
  }
}
