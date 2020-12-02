import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

class EventsScreen extends StatefulWidget {
  static const String id = 'events_screen';

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXTeal,
        title: Text('Events'),
      ),
    );
  }
}
