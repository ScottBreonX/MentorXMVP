import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/screens/chat_screen.dart';
import 'package:mentorx_mvp/screens/welcome_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String firstName;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        firstName = loggedInUser.email;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              await _auth.signOut();
              Navigator.popAndPushNamed(context, WelcomeScreen.id);
            },
          ),
        ],
        title: Text('MentorX'),
        backgroundColor: Color.fromRGBO(39, 163, 183, 0.7),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Welcome Back, $firstName'),
            RoundedButton(
              onPressed: () {
                Navigator.pushNamed(context, ChatScreen.id);
              },
              title: 'Chat Screen',
              color: Color.fromRGBO(39, 163, 183, 0.7),
            )
          ],
        ),
      ),
    );
  }
}