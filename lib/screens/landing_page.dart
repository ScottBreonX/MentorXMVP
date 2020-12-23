import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/welcome_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;
  static const String id = 'landing_page';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    super.initState();
    widget.auth.authStateChanges().listen((user) {
      print('uid: ${user?.uid}');
    });
    _updateUser(widget.auth.currentUser);
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return WelcomeScreen(
        auth: widget.auth,
        onSignIn: _updateUser,
      );
    }
    return LaunchScreen(
      auth: widget.auth,
      onSignOut: () => _updateUser(null),
    );
  }
}
