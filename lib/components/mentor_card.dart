import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:mentorx_mvp/constants.dart';

User loggedInUser;

class MentorCard extends StatelessWidget {
  final String mentorUID;
  final int mentorSlots;
  final String mentorFname;
  final String mentorLname;
  final String mentorEmail;

  MentorCard(
      {this.mentorUID,
      this.mentorSlots,
      this.mentorFname,
      this.mentorLname,
      this.mentorEmail});

  Future<void> _confirmMentorSelection(String mentorUID, BuildContext context,
      String mentorFName, String mentorLName) async {
    final didRequestMentor = await showAlertDialog(
      context,
      title: "Selection Confirmation",
      content: "Confirm selection of $mentorFname $mentorLname as Mentor?",
      defaultActionText: "Yes",
      cancelActionText: "No",
    );
    if (didRequestMentor == true) {
      // _createMentorMatch(mentorUID);
    }
  }

  // Future<void> _createMentorMatch(String mentorUID) async {
  //   try {
  //     final database =
  //         FirestoreDatabase(uid: loggedInUser.uid, mentorUID: mentorUID);
  //     await database.createMentorMatch(
  //       MentorMatchModel(
  //         menteeUID: loggedInUser.uid,
  //         mentorUID: mentorUID,
  //       ),
  //       mentorUID,
  //     );
  //     await database.createMatchID(
  //       MatchIDModel(
  //         mentorUID: mentorUID,
  //       ),
  //     );
  //     await FirebaseFirestore.instance
  //         .collection('mentoring')
  //         .doc('UniversityOfFlorida')
  //         .collection('mentors')
  //         .doc(mentorUID)
  //         .update({'Available Slots': mentorSlots - 1});
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700], width: 5),
              borderRadius: BorderRadius.circular(12),
              color: kMentorXPrimary,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  offset: Offset(2, 3),
                  color: Colors.grey[700],
                )
              ],
            ),
            width: double.infinity,
            height: 250,
            child: Column(
              // Material(
              // borderRadius: BorderRadius.circular(10.0),
              // elevation: 5.0,
              // color: Colors.grey,
              // child: Padding(
              //   padding: EdgeInsets.symmetric(
              //     vertical: 10.0,
              //     horizontal: 20.0,
              //   ),
              //   child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$mentorFname $mentorLname',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Available Slots: $mentorSlots',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedButton(
                      title: 'View Profile',
                      fontSize: 15,
                      buttonColor: Colors.grey[700],
                      borderRadius: 10.0,
                      fontColor: Colors.white,
                      minWidth: 300,
                      onPressed: () {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedButton(
                      title: 'Select Mentor',
                      fontSize: 15,
                      buttonColor: Colors.grey[700],
                      borderRadius: 10.0,
                      fontColor: Colors.white,
                      minWidth: 300,
                      onPressed: () async {
                        await _confirmMentorSelection(
                            mentorUID, context, mentorFname, mentorLname);
                        Navigator.pushNamed(context, MentoringScreen.id);
                      },
                    ),
                  ],
                ),
              ],
              // ),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
