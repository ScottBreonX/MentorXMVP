import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

class MyProfile extends StatefulWidget {
  static const String id = 'profile_screen';

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXTeal,
        title: Text('My Profile'),
      ),
    );
  }
}
