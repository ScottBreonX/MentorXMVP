import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mentorx_mvp/screens/chat_screen.dart';
import 'package:mentorx_mvp/screens/profile_screen.dart';
import 'profile_screen.dart';
import 'events_screen.dart';
import 'mentoring_screen.dart';

class LaunchScreen extends StatefulWidget {
  static const String id = 'launch_screen';

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXTeal,
        title: Text('Launch Screen'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
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
              height: 50,
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
                        radius: 60,
                        backgroundColor: kMentorXTeal,
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, EventsScreen.id);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: kMentorXTeal,
                        child: Icon(
                          Icons.calendar_today_rounded,
                          size: 80,
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
                        radius: 60,
                        backgroundColor: kMentorXTeal,
                        child: Icon(
                          Icons.people,
                          size: 80,
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
                  width: 50,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ChatScreen.id);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: kMentorXTeal,
                        child: Icon(
                          Icons.chat_bubble,
                          size: 80,
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
