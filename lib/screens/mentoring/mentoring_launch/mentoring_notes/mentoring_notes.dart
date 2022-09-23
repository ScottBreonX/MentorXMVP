import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_notes/mentoring_notes_add.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringNotes extends StatefulWidget {
  const MentoringNotes({
    Key key,
  }) : super(key: key);

  static const String id = 'mentoring_notes_screen';

  @override
  _MentoringNotesState createState() => _MentoringNotesState();
}

class _MentoringNotesState extends State<MentoringNotes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Image.asset(
          'assets/images/MentorPinkWhite.png',
          height: 150,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: IconCard(
                    cardColor: Colors.white,
                    cardIcon: Icons.add,
                    cardIconColor: Colors.blue,
                    iconSize: 50,
                    cardText: 'Add Note',
                    textSize: 20,
                    cardTextColor: Colors.black54,
                    boxWidth: 180,
                    boxHeight: 120,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MentoringNotesAdd(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: IconCard(
                    cardColor: Colors.white,
                    cardIcon: Icons.share,
                    cardIconColor: Colors.blue,
                    iconSize: 50,
                    cardText: 'Shared Notes',
                    textSize: 20,
                    cardTextColor: Colors.black54,
                    boxWidth: 180,
                    boxHeight: 120,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Divider(
                color: Colors.grey,
                thickness: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
