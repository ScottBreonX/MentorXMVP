import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';

import '../../../../components/alert_dialog.dart';
import '../../../../components/rounded_button.dart';
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
        "timeStamp": Timestamp.now(),
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
        elevation: 5,
        backgroundColor: kMentorXPPrimary,
        title: Image.asset(
          'assets/images/MentorXP.png',
          height: 100,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
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
                      fontFamily: 'Montserrat'),
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Montserrat',
                    ),
                    prefixIcon: Icon(
                      Icons.book,
                      size: 40,
                      color: kMentorXPSecondary,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0, top: 40),
                child: TextFormField(
                  key: _formKey2,
                  onChanged: (value) => noteText = value,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.start,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Notes',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Montserrat',
                    ),
                    prefixIcon: Icon(
                      Icons.notes,
                      size: 40,
                      color: kMentorXPSecondary,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedButton(
                    minWidth: 150,
                    title: 'Cancel',
                    prefixIcon: Icon(
                      Icons.close,
                      color: kMentorXPSecondary,
                      size: 20,
                    ),
                    textAlignment: MainAxisAlignment.center,
                    buttonColor: Colors.white,
                    fontSize: 20,
                    fontColor: Colors.black45,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RoundedButton(
                    minWidth: 150,
                    title: 'Save',
                    prefixIcon: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    textAlignment: MainAxisAlignment.center,
                    buttonColor: kMentorXPSecondary,
                    fontSize: 20,
                    fontColor: Colors.white,
                    onPressed: () async {
                      await _addNotes(
                          widget.programUID, widget.matchID, loggedInUser);
                      await _updateNoteID(
                              widget.programUID, widget.matchID, noteID)
                          .then((value) => Navigator.pop(context));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
