import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/mentor_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';

import '../../models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentorConfirm extends StatelessWidget {
  static const String id = 'mentor_confirm_screen';
  final myUser loggedInUser;
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
  final String programUID;
  final String mtrClass;
  final int mentorSlots;

  MentorConfirm({
    this.loggedInUser,
    this.mentorUID,
    this.mentorPicContainer,
    this.mentorFname,
    this.mentorLname,
    this.mentorMajor,
    this.mentorYearInSchool,
    this.mtrAtt1,
    this.mtrAtt2,
    this.mtrAtt3,
    this.xFactor,
    this.programUID,
    this.mtrClass,
    this.mentorSlots,
  });

  handleConfirmSelection() {
    //change Mentor Match in Mentees collection to True
    programsRef
        .doc(programUID)
        .collection('mentees')
        .doc(loggedInUser.id)
        .update({'Mentor Match': true});
    //add mentor to mentee match collection
    // programsRef
    //     .doc(programUID)
    //     .collection('userSubscribed')
    //     .doc(loggedInUser.id)
    //     .collection('matches')
    //     .doc(mentorUID)
    //     .set({});
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
    // decrement mentor available slots
    programsRef
        .doc(programUID)
        .collection('mentors')
        .doc(mentorUID)
        .update({"Mentor Slots": max(0, mentorSlots - 1)});
    //add mentor ID and mentee ID to matchID section
    programsRef
        .doc(programUID)
        .collection('matchedPairs')
        .doc(mentorUID + loggedInUser.id)
        .set({"mentor": mentorUID, "mentee": loggedInUser.id});
    //add program guides section for loggedInUser ID
    programsRef
        .doc(programUID)
        .collection('matchedPairs')
        .doc(mentorUID + loggedInUser.id)
        .collection('programGuides')
        .doc(loggedInUser.id)
        .set({});
    //add program guides section for loggedInUser ID
    programsRef
        .doc(programUID)
        .collection('matchedPairs')
        .doc(mentorUID + loggedInUser.id)
        .collection('programGuides')
        .doc(mentorUID)
        .set({});
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
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: kMentorXPAccentDark,
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
                      title: 'Return to program',
                      buttonColor: kMentorXPPrimary,
                      fontColor: Colors.white,
                      minWidth: 200,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramLaunchScreen(
                              loggedInUser: loggedInUser,
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
        backgroundColor: kMentorXPPrimary,
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Confirm selection of mentor:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                          color: kMentorXPPrimary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: MentorCard(
                        mentorUID: mentorUID,
                        loggedInUser: loggedInUser,
                        mentorFname: mentorFname,
                        mentorLname: mentorLname,
                        imageContainer: mentorPicContainer,
                        mtrAtt1: mtrAtt1,
                        mtrAtt2: mtrAtt2,
                        mtrAtt3: mtrAtt3,
                        xFactor: xFactor,
                        mtrClass: mtrClass,
                        // mentorSlots: mentorSlots,
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
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        minWidth: 150,
                        buttonColor: Colors.white,
                        fontColor: Colors.black45,
                        onPressed: () => Navigator.pop(context),
                      ),
                      RoundedButton(
                        title: 'Confirm',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        minWidth: 150,
                        buttonColor: kMentorXPAccentDark,
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
