import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_enrollment/mentor_enrollment_free_form.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/progress.dart';
import '../../../models/mentor_match_models/mentor_model.dart';
import '../../launch_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentorEnrollmentHobbies extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'mentor_enrollment_hobbies_screen';

  const MentorEnrollmentHobbies({
    this.loggedInUser,
    this.programUID,
  });

  @override
  State<MentorEnrollmentHobbies> createState() =>
      _MentorEnrollmentHobbiesState();
}

class _MentorEnrollmentHobbiesState extends State<MentorEnrollmentHobbies> {
  Future<void> _updateMentorHobbies(
      BuildContext context, String programUID) async {
    try {
      await programsRef
          .doc(programUID)
          .collection('mentors')
          .doc(loggedInUser.id)
          .update({
        "Mentor Hobby 1": hobby1,
        "Mentor Hobby 2": hobby2,
        "Mentor Hobby 3": hobby3,
        "id": loggedInUser.id,
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MentorEnrollmentFreeForm(
            loggedInUser: loggedInUser,
            programUID: programUID,
          ),
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  List<String> items = [
    'Coding',
    'Crafts',
    'Drawing',
    'Painting',
    'Robotics',
    'Sports',
    'Travel',
    'Video Games',
    'Volunteering',
  ];

  Map<String, IconData> map = {
    'Coding': Icons.code,
    'Crafts': Icons.format_paint,
    'Drawing': Icons.draw,
    'Painting': Icons.picture_as_pdf,
    'Robotics': Icons.military_tech,
    'Sports': Icons.sports,
    'Travel': Icons.travel_explore,
    'Video Games': Icons.gamepad,
    'Volunteering': Icons.help,
  };

  String hobby1;
  String hobby2;
  String hobby3;
  bool hobby3Changed = false;
  bool hobby2Changed = false;
  bool hobby1Changed = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('mentors')
            .doc(loggedInUser.id)
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
            body: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
              child: Column(
                children: [
                  Text(
                    'What are your top hobbies?',
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
                  dropDownSection(
                    titleText: 'Hobby #1',
                    skillValue: hobby1,
                    inputFunction: (value) => setState(() {
                      hobby1 = value ?? mentorSkills.mentorHobby1;
                      hobby1Changed = true;
                    }),
                    skillChanged: hobby1Changed,
                    currentValue: mentorSkills.mentorHobby1,
                  ),
                  dropDownSection(
                    titleText: 'Hobby #2',
                    skillValue: hobby2,
                    inputFunction: (value) => setState(() {
                      hobby2 = value ?? mentorSkills.mentorHobby2;
                      hobby2Changed = true;
                    }),
                    skillChanged: hobby2Changed,
                    currentValue: mentorSkills.mentorHobby2,
                  ),
                  dropDownSection(
                    titleText: 'Hobby #3',
                    skillValue: hobby3,
                    inputFunction: (value) => setState(() {
                      hobby3 = value ?? mentorSkills.mentorHobby1;
                      hobby3Changed = true;
                    }),
                    skillChanged: hobby3Changed,
                    currentValue: mentorSkills.mentorHobby3,
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
                          if (hobby1 == null) {
                            hobby1 = mentorSkills.mentorHobby1;
                          }
                          if (hobby2 == null) {
                            hobby2 = mentorSkills.mentorHobby2;
                          }
                          if (hobby3 == null) {
                            hobby3 = mentorSkills.mentorHobby3;
                          }
                          _updateMentorHobbies(context, widget.programUID);
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
                    'Select Item',
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
              color: kMentorXPSecondary,
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
