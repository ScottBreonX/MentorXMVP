import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
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

  String menteeFreeForm;

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
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 35.0, bottom: 10),
            child: Image.asset(
              'assets/images/MentorXP.png',
              fit: BoxFit.contain,
              height: 35,
            ),
          ),
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
                      fontWeight: FontWeight.w500,
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
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: buildFreeFormField(),
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
                      await _addNotes(widget.programUID, widget.matchID,
                          widget.loggedInUser);
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

  buildFreeFormField({
    String currentFreeFormResponse,
  }) {
    return TextFormField(
      key: _formKey2,
      style: TextStyle(
        color: Colors.black54,
        fontFamily: 'Montserrat',
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      autocorrect: true,
      initialValue: currentFreeFormResponse,
      onChanged: (value) => noteText = value,
      textCapitalization: TextCapitalization.sentences,
      minLines: 10,
      maxLines: 20,
      decoration: InputDecoration(
        hintStyle: TextStyle(
            color: kMentorXPSecondary.withOpacity(
              0.3,
            ),
            fontSize: 20,
            fontFamily: 'Montserrat'),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.black54,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: kMentorXPSecondary,
            width: 3.0,
          ),
        ),
        fillColor: Colors.white,
      ),
    );
  }
}
