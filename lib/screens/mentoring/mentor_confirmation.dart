import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';

class MentorConfirm extends StatelessWidget {
  static const String id = 'mentor_confirm_screen';
  final String mentorUID;
  final String mentorFname;
  final String mentorLname;
  final int mentorSlots;

  MentorConfirm({
    this.mentorUID,
    this.mentorFname,
    this.mentorLname,
    this.mentorSlots,
  });

  handleConfirmSelection() {
    // make current user a MENTEE of selected user
    mentorsRef
        .doc(mentorUID)
        .collection('userMentees')
        .doc(loggedInUser.id)
        .set({});
    // make selected user a MENTOR of current user
    menteesRef
        .doc(loggedInUser.id)
        .collection('userMentors')
        .doc(mentorUID)
        .set({});
    // decrement mentor's mentor slots
    usersRef.doc(mentorUID).update({
      "Mentor Slots": mentorSlots - 1,
    });
  }

  _createMentorMatch(BuildContext context) {
    handleConfirmSelection();
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Congrats!'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "You and $mentorFname $mentorLname have been matched",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              "Okay",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 3);
            },
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text('Confirm Mentor'),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 125, 20, 75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Confirm selection of Mentor:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline4.color,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ProfileImageCircle(iconSize: 100, circleSize: 80),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        '$mentorFname $mentorLname',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline4.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () => Navigator.pop(context),
                      heroTag: null,
                      backgroundColor: Colors.white,
                      label: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    FloatingActionButton.extended(
                      onPressed: () => _createMentorMatch(context),
                      heroTag: null,
                      label: Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
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
