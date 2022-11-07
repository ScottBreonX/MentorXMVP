import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_notes/mentoring_notes_view.dart';

class NotesTile extends StatelessWidget {
  final String titleText;
  final String noteText;
  final String mentorUID;
  final myUser loggedInUser;
  final String programUID;
  final String noteID;
  final String matchID;

  NotesTile({
    this.titleText,
    this.noteText,
    this.noteID,
    this.mentorUID,
    this.loggedInUser,
    this.programUID,
    this.matchID,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MentoringNotesView(
                      loggedInUser: loggedInUser,
                      noteID: noteID,
                      programUID: programUID,
                      matchID: matchID,
                      mentorUID: mentorUID,
                    )),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 10,
          child: Container(
            width: 220,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 350,
                  child: Center(
                    child: Text(
                      '$titleText',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
