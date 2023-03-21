import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/notes_model.dart';
import '../../../../components/alert_dialog.dart';
import '../../../../components/progress.dart';
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

  _confirmDeleteNote(parentContext, programUID, matchID, noteID) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                'Delete Note Confirmation',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      child: Column(
                        children: [
                          Text(
                            'Are you sure you want to delete this note?',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.black45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleDialogOption(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: RoundedButton(
                      title: 'Cancel',
                      prefixIcon: Icon(
                        Icons.close,
                        color: kMentorXPSecondary,
                      ),
                      buttonColor: Colors.white,
                      fontColor: Colors.black54,
                      minWidth: 120,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SimpleDialogOption(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: RoundedButton(
                      title: 'Yes',
                      prefixIcon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      buttonColor: kMentorXPPrimary,
                      fontColor: Colors.white,
                      minWidth: 120,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      onPressed: () async {
                        await _deleteNote(programUID, matchID, noteID);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

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

  Future<void> _deleteNote(
      String programID, String matchID, String noteID) async {
    try {
      await programsRef
          .doc(programID)
          .collection('matchedPairs')
          .doc(matchID)
          .collection('Notes')
          .doc(noteID)
          .delete();
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.noteID == null) {
      return circularProgress();
    }

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
        child: FutureBuilder<Object>(
            future: programsRef
                .doc(widget.programUID)
                .collection('matchedPairs')
                .doc(widget.matchID)
                .collection('Notes')
                .doc(widget.noteID)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              final notes = snapshot.data;
              Notes notesModel = Notes.fromDocument(notes);

              return Container(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 20),
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
                          fontWeight: FontWeight.w500,
                        ),
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
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        key: _formKey2,
                        onChanged: (value) => noteText = value,
                        initialValue: notesModel.noteText,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.start,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Notes',
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
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
                          minWidth: 120,
                          title: 'Delete',
                          textAlignment: MainAxisAlignment.center,
                          prefixIcon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          fontSize: 15,
                          buttonColor: kMentorXPPrimary,
                          fontColor: Colors.white,
                          onPressed: () {
                            _confirmDeleteNote(context, widget.programUID,
                                widget.matchID, widget.noteID);
                          },
                        ),
                        RoundedButton(
                          minWidth: 120,
                          title: 'Cancel',
                          prefixIcon: Icon(
                            Icons.close,
                            color: kMentorXPSecondary,
                          ),
                          textAlignment: MainAxisAlignment.center,
                          buttonColor: Colors.white,
                          fontSize: 15,
                          fontColor: Colors.black45,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        RoundedButton(
                          minWidth: 120,
                          title: 'Save',
                          textAlignment: MainAxisAlignment.center,
                          prefixIcon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          fontSize: 15,
                          buttonColor: kMentorXPSecondary,
                          fontColor: Colors.white,
                          onPressed: () async {
                            await _updateNotes(
                              widget.programUID,
                              widget.matchID,
                              widget.loggedInUser,
                              widget.noteID,
                            ).then((value) => Navigator.pop(context));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
