import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/notes_model.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';

import '../../../../components/alert_dialog.dart';
import '../../../../models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringNotesView extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;
  final String noteID;

  const MentoringNotesView({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
    this.noteID,
  }) : super(key: key);

  static const String id = 'mentoring_notes_view_screen';

  @override
  _MentoringNotesViewState createState() => _MentoringNotesViewState();
}

class _MentoringNotesViewState extends State<MentoringNotesView> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String titleText;
  String noteText;

  Future<void> _updateNotes(String programID, String matchID,
      myUser loggedInUser, String noteID) async {
    try {
      if (titleText != null) {
        await programsRef
            .doc(programID)
            .collection('matchedPairs')
            .doc(matchID)
            .collection('Notes')
            .doc(noteID)
            .update({
          "Title Text": titleText,
        });
      }
      if (noteText != null) {
        await programsRef
            .doc(programID)
            .collection('matchedPairs')
            .doc(matchID)
            .collection('Notes')
            .doc(noteID)
            .update({
          "Notes": noteText,
        });
      }
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
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
              onPressed: () async {
                await _updateNotes(
                  widget.programUID,
                  widget.matchID,
                  loggedInUser,
                  widget.noteID,
                );
                Navigator.pop(context);
              },
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
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<Object>(
            stream: programsRef
                .doc(widget.programUID)
                .collection('matchedPairs')
                .doc(widget.matchID)
                .collection('Notes')
                .doc(widget.noteID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center();
              }
              final notes = snapshot.data;
              Notes notesModel = Notes.fromDocument(notes);

              return Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        key: _formKey1,
                        initialValue: notesModel.titleText,
                        onChanged: (value) => titleText = value,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          prefixIcon: Icon(
                            Icons.book,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        key: _formKey2,
                        onChanged: (value) => noteText = value,
                        initialValue: notesModel.noteText,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Notes',
                          hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          prefixIcon: Icon(
                            Icons.notes,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
