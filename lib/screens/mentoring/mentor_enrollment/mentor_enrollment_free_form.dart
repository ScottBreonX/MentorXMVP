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

class MentorEnrollmentFreeForm extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'mentor_enrollment_free_form_screen';

  const MentorEnrollmentFreeForm({
    this.loggedInUser,
    this.programUID,
  });

  @override
  State<MentorEnrollmentFreeForm> createState() =>
      _MentorEnrollmentFreeFormState();
}

class _MentorEnrollmentFreeFormState extends State<MentorEnrollmentFreeForm> {
  Future<void> _updateMentorFreeForm(
      BuildContext context, String programUID, String freeFormResponse) async {
    try {
      await programsRef
          .doc(widget.programUID)
          .collection('mentors')
          .doc(widget.loggedInUser.id)
          .update({
        "Mentor Free Form": mentorFreeForm,
        "mentorSlots": 4,
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

  String mentorFreeForm;
  final _formKey1 = GlobalKey<FormState>();

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
              title: Image.asset(
                'assets/images/MentorXP.png',
                height: 100,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
                child: Column(
                  children: [
                    Text(
                      'Why would you make a great Mentor?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 30,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    buildFreeFormField(
                      hintString: 'I would be a good mentor because...',
                      icon: Icons.key,
                      minLines: 8,
                      currentFreeFormResponse: mentorSkills.mentorFreeForm,
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
                            if (mentorFreeForm == null) {
                              mentorFreeForm = mentorSkills.mentorFreeForm;
                            }
                            _updateMentorFreeForm(
                                context, widget.programUID, mentorFreeForm);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

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
      onChanged: (value) => mentorFreeForm = value,
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
}
