import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_enrollment/mentor_enrollment_free_form.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/progress.dart';
import '../../../models/mentor_match_models/mentor_model.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentorEnrollmentBackgroundV2Screen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'mentor_enrollment_background_v2_screen';

  const MentorEnrollmentBackgroundV2Screen({
    this.loggedInUser,
    this.programUID,
  });

  @override
  State<MentorEnrollmentBackgroundV2Screen> createState() =>
      _MentorEnrollmentBackgroundV2ScreenState();
}

class _MentorEnrollmentBackgroundV2ScreenState
    extends State<MentorEnrollmentBackgroundV2Screen> {
  Future<void> _updateMentorAttributes(BuildContext context, String programUID,
      String mentorOtherInfoText, String mentorYearInSchoolText) async {
    try {
      await programsRef
          .doc(widget.programUID)
          .collection('mentors')
          .doc(widget.loggedInUser.id)
          .update({
        "Mentor Other Info": mentorOtherInfoText,
        "Mentor Year in School": mentorYearInSchoolText,
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MentorEnrollmentFreeForm(
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

  String mentorOtherInfo;
  String mentorYearInSchool;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  buildFreeFormField({
    @required String hintString,
    @required IconData icon,
    @required int minLines,
    String currentFreeFormResponse,
  }) {
    return TextFormField(
      key: _formKey1,
      style: TextStyle(
        color: Colors.black54,
        fontFamily: 'Montserrat',
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      autocorrect: true,
      initialValue: currentFreeFormResponse,
      onChanged: (value) => mentorOtherInfo = value,
      textCapitalization: TextCapitalization.sentences,
      minLines: minLines,
      maxLines: minLines == null ? 1 : minLines + 1,
      decoration: InputDecoration(
        hintText: hintString,
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

  buildFreeFormField2({
    @required String hintString,
    @required IconData icon,
    @required int minLines,
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
      onChanged: (value) => mentorYearInSchool = value,
      textCapitalization: TextCapitalization.sentences,
      minLines: minLines,
      maxLines: minLines == null ? 1 : minLines + 1,
      decoration: InputDecoration(
        hintText: hintString,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('mentors')
            .doc(widget.loggedInUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
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
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                        child: Text(
                          'Is there anything else you would like to share with prospective mentees?',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: kMentorXPSecondary,
                          ),
                        ),
                      ),
                      buildFreeFormField(
                        hintString: 'other info...',
                        icon: Icons.key,
                        minLines: 5,
                        currentFreeFormResponse: mentorSkills.mentorOtherInfo,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                        child: Text(
                          'What year in school are you in this semester?',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: kMentorXPSecondary,
                          ),
                        ),
                      ),
                      buildFreeFormField2(
                        hintString: 'Freshman, Sophomore, Junior, Senior...',
                        icon: Icons.key,
                        minLines: 1,
                        currentFreeFormResponse:
                            mentorSkills.mentorYearInSchool,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundedButton(
                            title: '<-- Back',
                            buttonColor: Colors.white,
                            borderWidth: 2,
                            borderRadius: 20,
                            fontColor: kMentorXPSecondary,
                            fontWeight: FontWeight.w500,
                            minWidth: 150,
                            fontSize: 20,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          RoundedButton(
                            title: 'Next -->',
                            buttonColor: kMentorXPSecondary,
                            fontColor: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            borderRadius: 20,
                            minWidth: 150,
                            onPressed: () {
                              _updateMentorAttributes(
                                context,
                                widget.programUID,
                                mentorOtherInfo,
                                mentorYearInSchool,
                              );
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
}
