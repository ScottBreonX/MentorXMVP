import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';

class MentorCardTest extends StatelessWidget {
  final String mentorUID;
  final int mentorSlots;
  final String mentorFname;
  final String mentorLname;
  final String mentorEmail;
  final String mentorImgUrl;
  final String mentorMajor;
  final String mentorYearInSchool;

  MentorCardTest({
    this.mentorUID,
    this.mentorSlots,
    this.mentorFname,
    this.mentorLname,
    this.mentorEmail,
    this.mentorImgUrl,
    this.mentorMajor,
    this.mentorYearInSchool,
  });

//  Future<void> _confirmMentorSelection(String mentorUID, BuildContext context,
//      String mentorFName, String mentorLName) async {
//    final didRequestMentor = await showAlertDialog(
//      context,
//      title: "Selection Confirmation",
//      content: "Confirm selection of $mentorFname $mentorLname as Mentor?",
//      defaultActionText: "Yes",
//      cancelActionText: "No",
//    );
//    if (didRequestMentor == true) {
//      // _createMentorMatch(mentorUID);
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(profileId: mentorUID),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.94,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.28,
                    maxHeight: MediaQuery.of(context).size.width * 0.28,
                  ),
                  child: Image.asset(
                      mentorImgUrl != null
                          ? mentorImgUrl
                          : 'assets/images/UMichLogo.png',
                      fit: BoxFit.fitHeight),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Text(
                        '$mentorFname $mentorLname',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Text(
                        'Available Slots: $mentorSlots',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                      child: Text(
                        '$mentorMajor - $mentorYearInSchool',
                        style: TextStyle(
                          fontSize: 15,
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
    );
  }
}
