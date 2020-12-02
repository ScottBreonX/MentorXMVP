import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

class MentoringScreen extends StatefulWidget {
  static String id = 'mentoring_screen';

  @override
  _MentoringScreenState createState() => _MentoringScreenState();
}

class _MentoringScreenState extends State<MentoringScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXTeal,
        title: Text('Mentoring'),
      ),
    );
  }
}
