import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_enrollment/mentor_enrollment_review.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/progress.dart';
import '../../../models/mentor_match_models/mentor_model.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentorEnrollmentRequirementsScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'mentor_enrollment_requirements_screen';

  const MentorEnrollmentRequirementsScreen({
    this.loggedInUser,
    this.programUID,
  });

  @override
  State<MentorEnrollmentRequirementsScreen> createState() =>
      _MentorEnrollmentRequirementsScreenState();
}

class _MentorEnrollmentRequirementsScreenState
    extends State<MentorEnrollmentRequirementsScreen> {
  Future<void> _updateMentorAttributes(BuildContext context, String programUID,
      int mentorSlotsSelected, bool agreeToTerms) async {
    try {
      await programsRef
          .doc(widget.programUID)
          .collection('mentors')
          .doc(widget.loggedInUser.id)
          .update({
        "Mentor Slots": mentorSlotsSelected,
        "Acknowledge Terms": agreeToTerms,
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MentorEnrollmentReview(
            loggedInUser: widget.loggedInUser,
            programUID: widget.programUID,
          ),
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  int mentorSlots;
  String acknowledgeTerms;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return isChecked ? kMentorXPPrimary : Colors.black45;
    }

    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('mentors')
            .doc(widget.loggedInUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress(Theme.of(context).primaryColor);
          }

          final mentor = snapshot.data;
          Mentor mentorSkills = Mentor.fromDocument(mentor);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: kMentorXPPrimary,
              elevation: 5,
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
            body: Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 40),
                  child: Column(
                    children: [
                      Text(
                        'Mentor Enrollment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 30,
                          color: Colors.black54,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, bottom: 20),
                        child: Column(
                          children: [
                            Text(
                              'How many mentees can you support this semester?',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                color: kMentorXPPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'recommend at least 2',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, bottom: 10),
                              child: buildCounterWidget(),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                        child: Text(
                          'Are you willing to commit 1-2 hours a week to participate in this mentorship program?',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            color: kMentorXPPrimary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: isChecked,
                                onChanged: (bool value) async {
                                  setState(() {
                                    isChecked = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              'Yes',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: isChecked
                                    ? kMentorXPPrimary
                                    : Colors.black45,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundedButton(
                            title: '<-- Back',
                            buttonColor: Colors.white,
                            borderWidth: 2,
                            borderRadius: 20,
                            fontColor: kMentorXPPrimary,
                            fontWeight: FontWeight.w500,
                            minWidth: 150,
                            fontSize: 20,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          RoundedButton(
                            title: 'Next -->',
                            buttonColor: kMentorXPPrimary,
                            fontColor: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            borderRadius: 20,
                            minWidth: 150,
                            onPressed: () {
                              isChecked
                                  ? _updateMentorAttributes(
                                      context,
                                      widget.programUID,
                                      mentorSlots,
                                      isChecked,
                                    )
                                  : showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SimpleDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          title: Text(
                                            "Please confirm mentorship time commitment by selecting the checkbox",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontFamily: 'Montserrat',
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 50.0,
                                                right: 50,
                                              ),
                                              child: SimpleDialogOption(
                                                child: RoundedButton(
                                                  title: 'Ok',
                                                  textAlignment:
                                                      MainAxisAlignment.center,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  buttonColor: kMentorXPPrimary,
                                                  fontColor: Colors.white,
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _incrementCounter() {
    if (mentorSlots < 4) {
      setState(() {
        mentorSlots++;
      });
    }
  }

  void _decrementCounter() {
    if (mentorSlots > 1) {
      setState(() {
        mentorSlots--;
      });
    }
  }

  buildCounterWidget() {
    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('mentors')
            .doc(widget.loggedInUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          Mentor mentorModel = Mentor.fromDocument(snapshot.data);
          if (mentorSlots == null) {
            mentorSlots = 1;
          }
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  heroTag: 'decrement1',
                  onPressed: _decrementCounter,
                  child: Icon(
                    Icons.remove,
                    size: 30,
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: kMentorXPPrimary,
                  tooltip: 'Decrement',
                ),
              ),
              SizedBox(width: 25),
              Text(
                '$mentorSlots',
                style: TextStyle(
                  fontSize: 60.0,
                  fontFamily: 'Montserrat',
                  color: kMentorXPPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 25),
              Container(
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  heroTag: 'increment1',
                  onPressed: _incrementCounter,
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: kMentorXPPrimary,
                  tooltip: 'Increment',
                ),
              ),
            ],
          ));
        });
  }
}
