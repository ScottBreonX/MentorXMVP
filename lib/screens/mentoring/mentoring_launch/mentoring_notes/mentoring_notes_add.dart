import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';

import '../../../../components/alert_dialog.dart';
import '../../../../models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringNotesAdd extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const MentoringNotesAdd({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
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

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String titleText;
  String noteText;
  String noteID;

  Future<void> _addNotes(
      String programID, String matchID, myUser loggedInUser) async {
    try {
      await programsRef
          .doc(programID)
          .collection('matchedPairs')
          .doc(matchID)
          .collection('Notes')
          .add({
        "Title Text": titleText ?? "",
        "Notes": noteText ?? "",
        "Private or Public": "Private",
        "Owner": loggedInUser.id,
        "id": "",
      }).then((value) => noteID = value.id);
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  Future<void> _updateNoteID(
      String programID, String matchID, String noteID) async {
    try {
      await FirebaseFirestore.instance
          .collection('institutions')
          .doc(programID)
          .collection('matchedPairs')
          .doc(matchID)
          .collection("Notes")
          .doc(noteID)
          .update({"id": noteID});
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
                await _addNotes(
                    widget.programUID, widget.matchID, loggedInUser);
                await _updateNoteID(widget.programUID, widget.matchID, noteID)
                    .then((value) => Navigator.pop(context));
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
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: _formKey1,
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
        ),
      ),
    );
  }
}
