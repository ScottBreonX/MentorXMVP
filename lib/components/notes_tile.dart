import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_notes/mentoring_notes_view.dart';

import '../constants.dart';

class NotesTile extends StatelessWidget {
  final String titleText;
  final String noteText;
  final String mentorUID;
  final myUser loggedInUser;
  final String programUID;
  final String noteID;
  final String matchID;
  final Timestamp dateID;

  NotesTile(
      {this.titleText,
      this.noteText,
      this.noteID,
      this.mentorUID,
      this.loggedInUser,
      this.programUID,
      this.matchID,
      this.dateID});

  @override
  Widget build(BuildContext context) {
    String dateMonthDay(Timestamp dateID) {
      var format = DateFormat('MMMd'); // <- use skeleton here
      return format.format(dateID.toDate());
    }

    String dateYear(Timestamp dateID) {
      var format = DateFormat('yyy'); // <- use skeleton here
      return format.format(dateID.toDate());
    }

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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, bottom: 10, top: 10, right: 10.0),
                      child: Container(
                        child: Text(
                          '${dateMonthDay(dateID)}, ${dateYear(dateID)}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, bottom: 10, top: 10, right: 10.0),
                      child: Container(
                        child: Text(
                          'View / Edit',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: kMentorXPSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        child: Text(
                          '$titleText',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5),
                      child: Container(
                        width: 350,
                        child: Text(
                          '$noteText',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
