import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/mentor_match_models/mentee_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentee_enrollment/mentee_enrollment_review.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MenteeEnrollmentSkillsScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'mentee_enrollment_skills_screen';

  const MenteeEnrollmentSkillsScreen({
    this.loggedInUser,
    this.programUID,
  });

  @override
  State<MenteeEnrollmentSkillsScreen> createState() =>
      _MenteeEnrollmentSkillsScreenState();
}

class _MenteeEnrollmentSkillsScreenState
    extends State<MenteeEnrollmentSkillsScreen> {
  Future<void> _updateMenteeAttributes(
      BuildContext context, String programUID) async {
    try {
      await programsRef
          .doc(widget.programUID)
          .collection('mentees')
          .doc(widget.loggedInUser.id)
          .update({
        "Mentee Skill 1": skill1,
        "Mentee Skill 2": skill2,
        "Mentee Skill 3": skill3,
        "id": widget.loggedInUser.id,
        "First Name": widget.loggedInUser.firstName,
        "Last Name": widget.loggedInUser.lastName,
        "Profile Picture": widget.loggedInUser.profilePicture,
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenteeEnrollmentReview(
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

  List<String> items = [
    'Career Exploration',
    'Communication',
    'Internships',
    'Interview Prep',
    'Major Exploration',
    'Resumes',
    'Skill Development',
  ];

  Map<String, IconData> map = {
    'Career Exploration': Icons.business,
    'Communication': Icons.emoji_people,
    'Internships': Icons.work,
    'Interview Prep': Icons.people_alt_outlined,
    'Major Exploration': Icons.school,
    'Resumes': Icons.note,
    'Skill Development': Icons.leaderboard,
  };

  String skill1;
  String skill2;
  String skill3;
  bool skill3Changed = false;
  bool skill2Changed = false;
  bool skill1Changed = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('mentees')
            .doc(widget.loggedInUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          final mentee = snapshot.data;
          Mentee menteeSkills = Mentee.fromDocument(mentee);

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
            body: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
              child: Column(
                children: [
                  Text(
                    'What top 3 skills are you looking to enhance?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 30,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  dropDownSection(
                    titleText: 'Skill #1',
                    skillValue: skill1,
                    inputFunction: (value) => setState(() {
                      skill1 = value ?? menteeSkills.menteeSkill1;
                      skill1Changed = true;
                    }),
                    skillChanged: skill1Changed,
                    currentValue: menteeSkills.menteeSkill1,
                  ),
                  dropDownSection(
                    titleText: 'Skill #2',
                    skillValue: skill2,
                    inputFunction: (value) => setState(() {
                      skill2 = value;
                      skill2Changed = true;
                    }),
                    skillChanged: skill2Changed,
                    currentValue: menteeSkills.menteeSkill2,
                  ),
                  dropDownSection(
                    titleText: 'Skill #3',
                    skillValue: skill3,
                    inputFunction: (value) => setState(() {
                      skill3 = value;
                      skill3Changed = true;
                    }),
                    skillChanged: skill3Changed,
                    currentValue: menteeSkills.menteeSkill3,
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
                          if (skill1 == null) {
                            skill1 = menteeSkills.menteeSkill1;
                          }
                          if (skill2 == null) {
                            skill2 = menteeSkills.menteeSkill2;
                          }
                          if (skill3 == null) {
                            skill3 = menteeSkills.menteeSkill3;
                          }
                          _updateMenteeAttributes(context, widget.programUID);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  DropdownButtonHideUnderline dropDownSection({
    String titleText,
    String skillValue,
    bool skillChanged,
    String currentValue,
    final void Function(String) inputFunction,
  }) {
    return DropdownButtonHideUnderline(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10, top: 20),
                child: Text(
                  titleText,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          DropdownButton2(
            isExpanded: true,
            hint: Row(
              children: const [
                Expanded(
                  child: Text(
                    '<None Selected>',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: items
                .map((name) => DropdownMenuItem<String>(
                      value: name,
                      child: Row(
                        children: [
                          Icon(
                            map[name],
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ))
                .toList(),
            value: skillChanged ? skillValue : currentValue,
            onChanged: inputFunction,
            icon: const Icon(
              Icons.arrow_drop_down_circle_rounded,
            ),
            iconSize: 30,
            iconEnabledColor: Colors.white,
            buttonHeight: 60,
            buttonPadding: const EdgeInsets.only(left: 14, right: 14),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white,
              ),
              color: (currentValue == null && skillValue == null)
                  ? Colors.grey
                  : kMentorXPSecondary,
            ),
            buttonElevation: 4,
            itemHeight: 40,
            itemPadding: const EdgeInsets.only(left: 14, right: 14),
            dropdownMaxHeight: 200,
            dropdownOverButton: false,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(color: Colors.white),
              color: Colors.grey,
            ),
            dropdownElevation: 8,
            scrollbarRadius: const Radius.circular(50),
            scrollbarThickness: 15,
            scrollbarAlwaysShow: true,
            offset: const Offset(0, 13),
          ),
        ],
      ),
    );
  }
}
