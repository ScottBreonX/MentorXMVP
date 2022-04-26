import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/mentor_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';

class MentorConfirm extends StatelessWidget {
  static const String id = 'mentor_confirm_screen';
  final String mentorUID;
  final String mentorFname;
  final String mentorLname;
  final String mentorMajor;
  final String mentorYearInSchool;
  final String mtrAtt1;
  final String mtrAtt2;
  final String mtrAtt3;
  final String xFactor;
  final Container mentorPicContainer;
  final int mentorSlots;
  final String programUID;

  MentorConfirm({
    this.mentorUID,
    this.mentorPicContainer,
    this.mentorFname,
    this.mentorLname,
    this.mentorSlots,
    this.mentorMajor,
    this.mentorYearInSchool,
    this.mtrAtt1,
    this.mtrAtt2,
    this.mtrAtt3,
    this.xFactor,
    this.programUID,
  });

  handleConfirmSelection() {
    programsRef
        .doc(programUID)
        .collection('userSubscribed')
        .doc(loggedInUser.id)
        .set({
      'mentorSelected': mentorUID,
    });
    // make selected user a MENTOR of current user
    // menteesRef
    //     .doc(loggedInUser.id)
    //     .collection('userMentors')
    //     .doc(mentorUID)
    //     .set({});
    // decrement mentor's mentor slots
    usersRef.doc(mentorUID).update({
      "Mentor Slots": mentorSlots - 1,
    });
  }

  _successfulMatch(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                'Successful Mentor Match!',
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.pink,
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
                            'You have been successfully matched with $mentorFname $mentorLname',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.bold,
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
                      title: 'Return to program',
                      buttonColor: Colors.pink,
                      fontColor: Colors.white,
                      minWidth: 200,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      onPressed: () => handleConfirmSelection(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
                child: Text(
                  'Return to program launch page for next steps',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text('Confirm Selection'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Confirm selection of mentor:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: MentorCard(
                      mentorUID: mentorUID,
                      mentorFname: mentorFname,
                      mentorLname: mentorLname,
                      imageContainer: mentorPicContainer,
                      mentorMajor: mentorMajor,
                      mentorYearInSchool: mentorYearInSchool,
                      mtrAtt1: mtrAtt1,
                      mtrAtt2: mtrAtt2,
                      mtrAtt3: mtrAtt3,
                      xFactor: xFactor,
                      mentorSlots: mentorSlots,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoundedButton(
                      title: 'Back',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      minWidth: 150,
                      buttonColor: Colors.white,
                      fontColor: Colors.pink,
                      onPressed: () => Navigator.pop(context),
                    ),
                    RoundedButton(
                      title: 'Confirm',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      minWidth: 150,
                      buttonColor: Colors.pink,
                      fontColor: Colors.white,
                      onPressed: () async {
                        await handleConfirmSelection();
                        _successfulMatch(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
