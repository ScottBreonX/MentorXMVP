import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/mentor_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

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
    //add mentor to mentee match collection
    programsRef
        .doc(programUID)
        .collection('userSubscribed')
        .doc(loggedInUser.id)
        .collection('matches')
        .doc(mentorUID)
        .set({});
    //add matchID to mentee
    programsRef
        .doc(programUID)
        .collection('userSubscribed')
        .doc(loggedInUser.id)
        .collection('matches')
        .doc(mentorUID)
        .set({"matchID": mentorUID + loggedInUser.id});
    //add mentee to mentor match collection
    programsRef
        .doc(programUID)
        .collection('userSubscribed')
        .doc(mentorUID)
        .collection('matches')
        .doc(loggedInUser.id)
        .set({});
    //addMatchIDtoMentor
    programsRef
        .doc(programUID)
        .collection('userSubscribed')
        .doc(mentorUID)
        .collection('matches')
        .doc(loggedInUser.id)
        .set({"matchID": mentorUID + loggedInUser.id});
    //decrement mentor available slots
    programsRef
        .doc(programUID)
        .collection('mentors')
        .doc(mentorUID)
        .update({"mentorSlots": max(0, mentorSlots - 1)});
    //add mentor ID and mentee ID to matchID section
    programsRef
        .doc(programUID)
        .collection('matchedPairs')
        .doc(mentorUID + loggedInUser.id)
        .set({"mentor": mentorUID, "mentee": loggedInUser.id});
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramLaunchScreen(
                              programUID: programUID,
                            ),
                          ),
                        );
                      },
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
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
                        moreInfoExpand: Container(),
                        dividerExpand: Divider(
                          height: 0,
                          color: Colors.white,
                        ),
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
      ),
    );
  }
}
