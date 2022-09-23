import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_notes/notes_section.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringNotesAdd extends StatefulWidget {
  const MentoringNotesAdd({
    Key key,
  }) : super(key: key);

  static const String id = 'mentoring_notes_add_screen';

  @override
  _MentoringNotesAddState createState() => _MentoringNotesAddState();
}

class _MentoringNotesAddState extends State<MentoringNotesAdd> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 135,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  'SAVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ))
        ],
        elevation: 5,
        // title: Image.asset(
        //   'assets/images/MentorPinkWhite.png',
        //   height: 150,
        // ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              NoteSection(),
            ],
          ),
        ),
      ),
    );
  }
}
