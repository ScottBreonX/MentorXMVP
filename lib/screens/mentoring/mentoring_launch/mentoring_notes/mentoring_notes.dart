import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/notes_tile.dart';
import 'package:mentorx_mvp/models/notes_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_notes/mentoring_notes_add.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringNotes extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const MentoringNotes({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
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
                          builder: (context) => MentoringNotesAdd(
                            mentorUID: widget.mentorUID,
                            matchID: widget.matchID,
                            programUID: widget.programUID,
                            loggedInUser: widget.loggedInUser,
                          ),
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: AvailableNotesStream(
                    programUID: widget.programUID,
                    matchID: widget.matchID,
                    mentorUID: widget.mentorUID,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvailableNotesStream extends StatelessWidget {
  final String programUID;
  final String matchID;
  final String mentorUID;

  AvailableNotesStream({this.programUID, this.matchID, this.mentorUID});

  @override
  Widget build(BuildContext context) {
    final Stream noteStream = programsRef
        .doc(programUID)
        .collection('matchedPairs')
        .doc(matchID)
        .collection('Notes')
        // .where('Private or Public', isEqualTo: 'Private')
        .orderBy('timeStamp', descending: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: noteStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center();
        }
        final notes = snapshot.data.docs;

        List<NotesTile> noteBubbles = [];

        for (var note in notes) {
          Notes noteInfo = Notes.fromDocument(note);

          final noteBubble = NotesTile(
            titleText: noteInfo.titleText,
            noteText: noteInfo.noteText,
            noteID: noteInfo.noteID,
            loggedInUser: loggedInUser,
            mentorUID: mentorUID,
            matchID: matchID,
            programUID: programUID,
            dateID: noteInfo.dateID,
          );
          noteBubbles.add(noteBubble);
        }
        return Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: noteBubbles,
          ),
        );
      },
    );
  }
}
