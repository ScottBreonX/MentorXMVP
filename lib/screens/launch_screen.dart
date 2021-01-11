import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mentorx_mvp/screens/chat_screen.dart';
import 'package:mentorx_mvp/screens/profile_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'profile_screen.dart';
import 'events_screen.dart';
import 'mentoring_screen.dart';
import 'package:mentorx_mvp/components/sign_out.dart';

User loggedInUser;

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({this.onSignOut});

  static const String id = 'launch_screen';
  final VoidCallback onSignOut;

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  void getCurrentUser() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              confirmSignOut(context);
            },
          ),
        ],
        backgroundColor: kMentorXTeal,
        title: Text('Home Screen'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 240,
                  child: ColorizeAnimatedTextKit(
                    speed: Duration(milliseconds: 1000),
                    text: ['Mentor'],
                    textStyle: TextStyle(
                      fontSize: 70.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    colors: [
                      Colors.grey,
                      Colors.white,
                      kMentorXTeal,
                      Colors.white,
                      Colors.grey,
                    ],
                    textAlign: TextAlign.start,
                    alignment: AlignmentDirectional.topStart,
                  ),
                ),
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/XLogo.png'),
                    height: 100.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MyProfile.id);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: kMentorXTeal,
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, EventsScreen.id);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: kMentorXTeal,
                        child: Icon(
                          Icons.calendar_today_rounded,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Events',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MentoringScreen.id);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: kMentorXTeal,
                        child: Icon(
                          Icons.people,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Mentoring',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ChatScreen.id);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: kMentorXTeal,
                        child: Icon(
                          Icons.chat_bubble,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
